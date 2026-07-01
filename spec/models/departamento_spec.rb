require 'rails_helper'

RSpec.describe Departamento, type: :model do
  context "validações" do
    it "é válido com todos os atributos obrigatórios" do
      dep = Departamento.new(nome: "Ciência da Computação", codigo: "CIC")
      expect(dep).to be_valid
    end

    it "não é válido sem nome" do
      dep = Departamento.new(codigo: "CIC")
      expect(dep).not_to be_valid
      expect(dep.errors[:nome]).to be_present
    end

    it "não é válido sem codigo" do
      dep = Departamento.new(nome: "Ciência da Computação")
      expect(dep).not_to be_valid
      expect(dep.errors[:codigo]).to be_present
    end

    it "não é válido com codigo duplicado" do
      Departamento.create!(nome: "CIC Original", codigo: "CIC")
      outro = Departamento.new(nome: "CIC Duplicado", codigo: "CIC")
      expect(outro).not_to be_valid
      expect(outro.errors[:codigo]).to be_present
    end

    it "é válido com codigos distintos" do
      Departamento.create!(nome: "CIC", codigo: "CIC")
      outro = Departamento.new(nome: "MAT", codigo: "MAT")
      expect(outro).to be_valid
    end
  end

  context "associações" do
    it "possui associação com cursos" do
      expect(Departamento.new).to respond_to(:cursos)
    end

    it "possui associação com disciplinas" do
      expect(Departamento.new).to respond_to(:disciplinas)
    end

    it "possui associação com administradores" do
      expect(Departamento.new).to respond_to(:administradores)
    end
  end
end
