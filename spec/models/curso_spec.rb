require 'rails_helper'

RSpec.describe Curso, type: :model do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }

  context "validações" do
    it "é válido com todos os atributos obrigatórios" do
      curso = Curso.new(nome: "Engenharia de Software", codigo: "ESW", departamento: departamento)
      expect(curso).to be_valid
    end

    it "não é válido sem nome" do
      curso = Curso.new(codigo: "ESW", departamento: departamento)
      expect(curso).not_to be_valid
      expect(curso.errors[:nome]).to be_present
    end

    it "não é válido sem codigo" do
      curso = Curso.new(nome: "Engenharia de Software", departamento: departamento)
      expect(curso).not_to be_valid
      expect(curso.errors[:codigo]).to be_present
    end

    it "não é válido sem departamento" do
      curso = Curso.new(nome: "Engenharia de Software", codigo: "ESW")
      expect(curso).not_to be_valid
    end

    it "não é válido com codigo duplicado" do
      Curso.create!(nome: "ES Original", codigo: "ESW", departamento: departamento)
      outro = Curso.new(nome: "ES Duplicado", codigo: "ESW", departamento: departamento)
      expect(outro).not_to be_valid
      expect(outro.errors[:codigo]).to be_present
    end

    it "é válido com codigos distintos no mesmo departamento" do
      Curso.create!(nome: "ES", codigo: "ESW", departamento: departamento)
      outro = Curso.new(nome: "CC", codigo: "CC01", departamento: departamento)
      expect(outro).to be_valid
    end
  end

  context "associações" do
    it "possui associação com discentes" do
      expect(Curso.new).to respond_to(:discentes)
    end

    it "possui associação com departamento" do
      expect(Curso.new).to respond_to(:departamento)
    end
  end
end
