require "rails_helper"

RSpec.describe Template, type: :model do
  let(:user) do
    User.create!(
      nome: "Administrador Teste",
      email: "admin_template_spec@camaar.com",
      matricula: "123456789",
      perfil: "Administrador",
      password: "123456",
      password_confirmation: "123456"
    )
  end

  it "é válido com nome, semestre e usuário" do
    template = described_class.new(
      nome: "Avaliação Docente",
      semestre: "2024.1",
      user: user
    )

    expect(template).to be_valid
  end

  it "é inválido sem nome" do
    template = described_class.new(
      nome: nil,
      semestre: "2024.1",
      user: user
    )

    expect(template).not_to be_valid
  end

  it "é inválido sem semestre" do
    template = described_class.new(
      nome: "Avaliação Docente",
      semestre: nil,
      user: user
    )

    expect(template).not_to be_valid
  end

  it "é inválido sem usuário" do
    template = described_class.new(
      nome: "Avaliação Docente",
      semestre: "2024.1",
      user: nil
    )

    expect(template).not_to be_valid
  end
end
