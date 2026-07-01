require 'rails_helper'

RSpec.describe Turma, type: :model do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let(:disciplina) { Disciplina.find_or_create_by!(nome: "Engenharia de Software", codigo: "CIC0097", departamento: departamento) }

  context "validações" do
    it "é válida com todos os atributos obrigatórios" do
      turma = Turma.new(numero_da_turma: "TA", semestre: "2026.1", disciplina: disciplina)
      expect(turma).to be_valid
    end

    it "não é válida sem numero_da_turma" do
      turma = Turma.new(semestre: "2026.1", disciplina: disciplina)
      expect(turma).not_to be_valid
      expect(turma.errors[:numero_da_turma]).to be_present
    end

    it "não é válida sem semestre" do
      turma = Turma.new(numero_da_turma: "TA", disciplina: disciplina)
      expect(turma).not_to be_valid
      expect(turma.errors[:semestre]).to be_present
    end

    it "não é válida sem disciplina" do
      turma = Turma.new(numero_da_turma: "TA", semestre: "2026.1")
      expect(turma).not_to be_valid
    end

    it "não é válida com numero_da_turma duplicado no mesmo semestre e disciplina" do
      Turma.create!(numero_da_turma: "TA", semestre: "2026.1", disciplina: disciplina)
      outra = Turma.new(numero_da_turma: "TA", semestre: "2026.1", disciplina: disciplina)
      expect(outra).not_to be_valid
      expect(outra.errors[:numero_da_turma]).to be_present
    end

    it "é válida com mesmo numero_da_turma em semestres distintos" do
      Turma.create!(numero_da_turma: "TA", semestre: "2026.1", disciplina: disciplina)
      outra = Turma.new(numero_da_turma: "TA", semestre: "2026.2", disciplina: disciplina)
      expect(outra).to be_valid
    end

    it "é válida com numero_da_turma distinto no mesmo semestre" do
      Turma.create!(numero_da_turma: "TA", semestre: "2026.1", disciplina: disciplina)
      outra = Turma.new(numero_da_turma: "TB", semestre: "2026.1", disciplina: disciplina)
      expect(outra).to be_valid
    end
  end

  context "associações" do
    it "possui associação com formularios" do
      expect(Turma.new).to respond_to(:formularios)
    end

    it "possui associação com discentes" do
      expect(Turma.new).to respond_to(:discentes)
    end

    it "possui associação com docentes" do
      expect(Turma.new).to respond_to(:docentes)
    end

    it "possui associação com disciplina" do
      expect(Turma.new).to respond_to(:disciplina)
    end
  end
end
