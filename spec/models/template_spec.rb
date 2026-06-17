require 'rails_helper'

RSpec.describe Template, type: :model do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let(:admin) do
    Administrador.find_or_create_by!(email: "admin_template@unb.br") do |u|
      u.nome = "Admin Template"
      u.matricula = "78910"
      u.senha = "Senha123"
      u.departamento = departamento
    end
  end

  context "validações de criação e relacionamento" do
    it "é válido com nome, um administrador e pelo menos um elemento" do
      template = Template.new(nome: "Avaliação da Turma", administrador: admin)
      template.elementos.build(enunciado: "Questão 1", ordem: 1)

      expect(template).to be_valid
    end

    it "não é válido sem um nome (título)" do
      template = Template.new(nome: "", administrador: admin)
      template.elementos.build(enunciado: "Questão 1", ordem: 1)

      expect(template).not_to be_valid
    end

    it "não é válido sem um administrador associado" do
      template = Template.new(nome: "Formulário Fantasma", administrador: nil)
      template.elementos.build(enunciado: "Questão 1", ordem: 1)

      expect(template).not_to be_valid
    end

    it "não é válido se não possuir nenhum elemento (questão)" do
      template = Template.new(nome: "Formulário Vazio", administrador: admin)

      expect(template).not_to be_valid
    end
  end
end
