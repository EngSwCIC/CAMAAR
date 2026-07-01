require 'rails_helper'

RSpec.describe Administrador, type: :model do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }

  context "validações de criação" do
    it "é válido com todos os atributos obrigatórios" do
      admin = Administrador.new(
        nome: "Admin Teste",
        matricula: "admin123",
        email: "admin@unb.br",
        senha: "Senha123",
        departamento: departamento
      )
      expect(admin).to be_valid
    end

    it "não é válido sem um nome" do
      admin = Administrador.new(
        nome: nil,
        matricula: "admin123",
        email: "admin@unb.br",
        senha: "Senha123",
        departamento: departamento
      )
      expect(admin).not_to be_valid
    end

    it "não é válido sem um departamento associado" do
      admin = Administrador.new(
        nome: "Admin Teste",
        matricula: "admin123",
        email: "admin@unb.br",
        senha: "Senha123",
        departamento: nil
      )
      expect(admin).not_to be_valid
    end
  end
end
