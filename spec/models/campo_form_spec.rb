require 'rails_helper'

RSpec.describe CampoForm, type: :model do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let(:disciplina) { Disciplina.find_or_create_by!(nome: "Engenharia de Software", codigo: "CIC0097", departamento: departamento) }
  let(:turma) { Turma.find_or_create_by!(numero_da_turma: "TA", disciplina: disciplina, semestre: "2026.1") }
  let(:formulario) { Formulario.create!(turma: turma) }
  let(:elemento_form) { ElementoForm.create!(ordem: 1, formulario: formulario) }

  context "validações" do
    it "é válido com todos os atributos obrigatórios" do
      cf = CampoForm.new(ordem: 1, elemento_form: elemento_form)
      expect(cf).to be_valid
    end

    it "não é válido sem ordem" do
      cf = CampoForm.new(elemento_form: elemento_form)
      expect(cf).not_to be_valid
      expect(cf.errors[:ordem]).to be_present
    end

    it "não é válido sem elemento_form" do
      cf = CampoForm.new(ordem: 1)
      expect(cf).not_to be_valid
    end
  end

  context "associações" do
    it "possui associação com resposta_elems" do
      expect(CampoForm.new).to respond_to(:resposta_elems)
    end

    it "possui associação com elemento_form" do
      expect(CampoForm.new).to respond_to(:elemento_form)
    end
  end
end
