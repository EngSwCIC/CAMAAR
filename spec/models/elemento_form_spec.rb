require 'rails_helper'

RSpec.describe ElementoForm, type: :model do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let(:disciplina) { Disciplina.find_or_create_by!(nome: "Engenharia de Software", codigo: "CIC0097", departamento: departamento) }
  let(:turma) { Turma.find_or_create_by!(numero_da_turma: "TA", disciplina: disciplina, semestre: "2026.1") }
  let(:formulario) { Formulario.create!(turma: turma) }

  context "validações" do
    it "é válido com todos os atributos obrigatórios" do
      ef = ElementoForm.new(ordem: 1, formulario: formulario)
      expect(ef).to be_valid
    end

    it "não é válido sem ordem" do
      ef = ElementoForm.new(formulario: formulario)
      expect(ef).not_to be_valid
      expect(ef.errors[:ordem]).to be_present
    end

    it "não é válido sem formulario" do
      ef = ElementoForm.new(ordem: 1)
      expect(ef).not_to be_valid
    end
  end

  context "associações" do
    it "possui associação com campo_forms" do
      expect(ElementoForm.new).to respond_to(:campo_forms)
    end

    it "possui associação com formulario" do
      expect(ElementoForm.new).to respond_to(:formulario)
    end
  end
end
