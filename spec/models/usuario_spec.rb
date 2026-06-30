require "rails_helper"

RSpec.describe Usuario, type: :model do
  subject(:usuario) do
    described_class.new(
      nome: "Maria Silva",
      email: "maria@example.com",
      password: "Senha123",
      password_confirmation: "Senha123"
    )
  end

  it "é válido com os dados necessários" do
    expect(usuario).to be_valid
  end

  it "exige nome" do
    usuario.nome = nil

    expect(usuario).not_to be_valid
    expect(usuario.errors[:nome]).to include("é obrigatório")
  end

  it "exige email em formato válido" do
    usuario.email = "email-invalido"

    expect(usuario).not_to be_valid
    expect(usuario.errors[:email]).to include("é inválido")
  end

  it "não permite email duplicado sem diferenciar maiúsculas de minúsculas" do
    usuario.save!
    duplicado = described_class.new(
      nome: "Outro Usuário",
      email: "MARIA@EXAMPLE.COM",
      password: "Senha123",
      password_confirmation: "Senha123"
    )

    expect(duplicado).not_to be_valid
    expect(duplicado.errors[:email]).to be_present
  end

  it "normaliza o email antes de validar" do
    usuario.email = "  MARIA@EXAMPLE.COM "
    usuario.validate

    expect(usuario.email).to eq("maria@example.com")
  end

  it "exige senha com no mínimo oito caracteres, letras e números" do
    usuario.password = "somenteletras"
    usuario.password_confirmation = "somenteletras"

    expect(usuario).not_to be_valid
    expect(usuario.errors[:password]).to include(
      "deve ter no mínimo 8 caracteres, incluindo letras e números"
    )
  end

  it "exige confirmação igual à senha" do
    usuario.password_confirmation = "Outra123"

    expect(usuario).not_to be_valid
    expect(usuario.errors[:password_confirmation]).to be_present
  end

  it "exige a confirmação da senha" do
    usuario.password_confirmation = nil

    expect(usuario).not_to be_valid
    expect(usuario.errors[:password_confirmation]).to include("é obrigatória")
  end

  it "rejeita senhas maiores que o limite de 72 bytes do BCrypt" do
    senha = "Senha123" + ("a" * 65)
    usuario.password = senha
    usuario.password_confirmation = senha

    expect(usuario).not_to be_valid
    expect(usuario.errors[:password]).to be_present
  end

  it "não define um perfil padrão para criações fora do cadastro público" do
    expect(usuario.role).to be_nil
  end

  it "armazena a senha de forma autenticável" do
    usuario.save!

    expect(usuario.password_digest).to be_present
    expect(usuario.authenticate("Senha123")).to eq(usuario)
  end
end
