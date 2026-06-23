require "rails_helper"

RSpec.describe Sigaa::DataSynchronizer do
  let!(:admin) { create(:user, :admin) }
  let(:classes_path) { Rails.root.join("tmp", "spec_sync_classes.json") }
  let(:members_path) { Rails.root.join("tmp", "spec_sync_members.json") }
  let(:semester) { "2021.2" }

  after do
    File.delete(classes_path) if File.exist?(classes_path)
    File.delete(members_path) if File.exist?(members_path)
  end

  it "sincroniza turmas e participantes do periodo informado" do
    write_classes_file([
      {
        "code" => "CIC0097",
        "name" => "BANCOS DE DADOS",
        "class" => { "classCode" => "TA", "semester" => "2021.2", "time" => "35T45" }
      }
    ])
    write_members_file([
      {
        "code" => "CIC0097",
        "classCode" => "TA",
        "semester" => "2021.2",
        "dicente" => [
          { "nome" => "Ana Clara Jordao Perna", "matricula" => "190084006", "email" => "acjpjvjp@gmail.com" }
        ],
        "docente" => {
          "nome" => "Maristela Terto de Holanda",
          "usuario" => "83807519491",
          "email" => "mholanda@unb.br"
        }
      }
    ])

    result = described_class.new(semester:, imported_by: admin, classes_path:, members_path:).call

    expect(result.already_up_to_date?).to be(false)
    expect(result.created_count).to be >= 3
    expect(CourseClass.find_by!(code: "CIC0097", semester: "2021.2")).to be_present
    expect(User.find_by!(registration: "190084006")).to be_present
    expect(User.find_by!(registration: "83807519491")).to be_present
    expect(ClassMembership.docente.count).to eq(1)
  end

  it "informa que a base ja esta atualizada quando nao ha mudancas" do
    write_classes_file([
      {
        "code" => "CIC0097",
        "name" => "BANCOS DE DADOS",
        "class" => { "classCode" => "TA", "semester" => "2021.2", "time" => "35T45" }
      }
    ])
    write_members_file([
      {
        "code" => "CIC0097",
        "classCode" => "TA",
        "semester" => "2021.2",
        "dicente" => [
          { "nome" => "Ana Clara Jordao Perna", "matricula" => "190084006", "email" => "acjpjvjp@gmail.com" }
        ]
      }
    ])

    synchronizer = described_class.new(semester:, imported_by: admin, classes_path:, members_path:)
    synchronizer.call
    result = synchronizer.call

    expect(result.already_up_to_date?).to be(true)
    expect(result.created_count).to eq(0)
    expect(result.updated_count).to eq(0)
  end

  def write_classes_file(payload)
    File.write(classes_path, JSON.pretty_generate(payload))
  end

  def write_members_file(payload)
    File.write(members_path, JSON.pretty_generate(payload))
  end
end
