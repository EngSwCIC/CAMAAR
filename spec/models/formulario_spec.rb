require 'rails_helper'

RSpec.describe Formulario, type: :model do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let(:disciplina) { Disciplina.find_or_create_by!(nome: "Engenharia de Software", codigo: "CIC0097", departamento: departamento) }
  let(:turma) { Turma.find_or_create_by!(numero_da_turma: "TA", disciplina: disciplina, semestre: "2026.1") }

  context "validações de criação e relacionamentos" do
    it "é válido quando associado a uma turma" do
      formulario = Formulario.new(turma: turma)
      expect(formulario).to be_valid
    end

    it "não é válido sem estar vinculado a uma turma" do
      formulario = Formulario.new(turma: nil)
      expect(formulario).not_to be_valid
    end

    it "possui relacionamento com elemento_forms" do
      formulario = Formulario.new(turma: turma)
      expect(formulario).to respond_to(:elemento_forms)
    end

    it "possui relacionamento com resposta_forms" do
      formulario = Formulario.new(turma: turma)
      expect(formulario).to respond_to(:resposta_forms)
    end
  end
end
