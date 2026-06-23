require "rails_helper"

RSpec.describe Sigaa::ClassMembersImporter do
  let!(:admin) { create(:user, :admin) }
  let(:path) { Rails.root.join("tmp", "spec_class_members.json") }

  after do
    File.delete(path) if File.exist?(path)
  end

  it "cadastra participantes novos, associa turma e envia link de definicao de senha" do
    write_import_file([
      {
        "code" => "CIC0097",
        "classCode" => "TA",
        "semester" => "2021.2",
        "dicente" => [
          {
            "nome" => "Ana Clara Jordao Perna",
            "matricula" => "190084006",
            "email" => "acjpjvjp@gmail.com"
          }
        ]
      }
    ])

    result = described_class.new(path:, imported_by: admin).call

    user = User.find_by!(registration: "190084006")
    expect(result.created_count).to eq(2)
    expect(user.name).to eq("Ana Clara Jordao Perna")
    expect(user.email).to eq("acjpjvjp@gmail.com")
    expect(user).to be_pending_password_setup
    expect(user.password_setup_token_digest).to be_present
    expect(user.class_memberships.first).to be_discente
    expect(user.course_classes.first.code).to eq("CIC0097")
    expect(ActionMailer::Base.deliveries.last.to).to include("acjpjvjp@gmail.com")
    expect(ActionMailer::Base.deliveries.last.body.encoded).to include("senha/definir")
  end

  it "nao duplica usuario ja cadastrado e mantem uma unica conta por matricula e email" do
    create(:user, name: "Ana", email: "acjpjvjp@gmail.com", registration: "190084006", password: "Senha@123")

    write_import_file([
      {
        "code" => "CIC0097",
        "classCode" => "TA",
        "semester" => "2021.2",
        "dicente" => [
          {
            "nome" => "Ana Clara Jordao Perna",
            "matricula" => "190084006",
            "email" => "acjpjvjp@gmail.com"
          }
        ]
      }
    ])

    expect do
      described_class.new(path:, imported_by: admin).call
    end.not_to change(User, :count)

    expect(User.where(registration: "190084006").count).to eq(1)
    expect(User.where(email: "acjpjvjp@gmail.com").count).to eq(1)
    expect(User.find_by!(registration: "190084006").course_classes.count).to eq(1)
  end

  it "registra inconsistencia e continua processando os participantes validos" do
    write_import_file([
      {
        "code" => "CIC0097",
        "classCode" => "TA",
        "semester" => "2021.2",
        "dicente" => [
          {
            "nome" => "Participante Invalido",
            "matricula" => "",
            "email" => ""
          },
          {
            "nome" => "Ana Clara Jordao Perna",
            "matricula" => "190084006",
            "email" => "acjpjvjp@gmail.com"
          }
        ]
      }
    ])

    result = described_class.new(path:, imported_by: admin).call

    expect(result.inconsistencies).to eq(1)
    expect(ImportInconsistency.last.message).to eq("Participante sem email ou matricula")
    expect(User.exists?(name: "Participante Invalido")).to be(false)
    expect(User.exists?(registration: "190084006")).to be(true)
  end

  def write_import_file(payload)
    File.write(path, JSON.pretty_generate(payload))
  end
end
