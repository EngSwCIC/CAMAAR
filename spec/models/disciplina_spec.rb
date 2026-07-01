require 'rails_helper'

RSpec.describe Disciplina, type: :model do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }

  context "validações" do
    it "é válida com todos os atributos obrigatórios" do
      disciplina = Disciplina.new(nome: "Engenharia de Software", codigo: "CIC0097", departamento: departamento)
      expect(disciplina).to be_valid
    end

    it "não é válida sem nome" do
      disciplina = Disciplina.new(codigo: "CIC0097", departamento: departamento)
      expect(disciplina).not_to be_valid
      expect(disciplina.errors[:nome]).to be_present
    end

    it "não é válida sem codigo" do
      disciplina = Disciplina.new(nome: "Engenharia de Software", departamento: departamento)
      expect(disciplina).not_to be_valid
      expect(disciplina.errors[:codigo]).to be_present
    end

    it "não é válida sem departamento" do
      disciplina = Disciplina.new(nome: "Engenharia de Software", codigo: "CIC0097")
      expect(disciplina).not_to be_valid
    end

    it "não é válida com codigo duplicado" do
      Disciplina.create!(nome: "ES Original", codigo: "CIC0097", departamento: departamento)
      outra = Disciplina.new(nome: "ES Duplicada", codigo: "CIC0097", departamento: departamento)
      expect(outra).not_to be_valid
      expect(outra.errors[:codigo]).to be_present
    end

    it "é válida com codigos distintos" do
      Disciplina.create!(nome: "ES", codigo: "CIC0097", departamento: departamento)
      outra = Disciplina.new(nome: "BD", codigo: "CIC0098", departamento: departamento)
      expect(outra).to be_valid
    end
  end

  context "associações" do
    it "possui associação com turmas" do
      expect(Disciplina.new).to respond_to(:turmas)
    end

    it "possui associação com departamento" do
      expect(Disciplina.new).to respond_to(:departamento)
    end
  end
end
