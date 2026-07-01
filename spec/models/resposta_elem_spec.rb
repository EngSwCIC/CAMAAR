require 'rails_helper'

RSpec.describe RespostaElem, type: :model do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let(:disciplina) { Disciplina.find_or_create_by!(nome: "Engenharia de Software", codigo: "CIC0097", departamento: departamento) }
  let(:turma) { Turma.find_or_create_by!(numero_da_turma: "TA", disciplina: disciplina, semestre: "2026.1") }
  let(:formulario) { Formulario.create!(turma: turma) }
  let(:elemento_form) { ElementoForm.create!(ordem: 1, tipo: "Texto", formulario: formulario) }
  let(:docente) do
    Docente.find_or_create_by!(email: "doc_re@unb.br") do |d|
      d.nome = "Docente RE"
      d.matricula = "doc_re001"
      d.formacao = "Doutorado"
      d.senha = "Senha123"
    end
  end
  let(:resposta_form) do
    RespostaForm.create!(data_submissao: Date.today, formulario: formulario, usuario: docente)
  end

  context "validações" do
    it "é válido com todos os atributos obrigatórios" do
      re = RespostaElem.new(
        texto_resposta: "Muito bom",
        resposta_form: resposta_form,
        elemento_form: elemento_form
      )
      expect(re).to be_valid
    end

    it "não é válido sem texto_resposta" do
      re = RespostaElem.new(resposta_form: resposta_form, elemento_form: elemento_form)
      expect(re).not_to be_valid
      expect(re.errors[:texto_resposta]).to be_present
    end

    it "não é válido sem resposta_form" do
      re = RespostaElem.new(texto_resposta: "Bom", elemento_form: elemento_form)
      expect(re).not_to be_valid
    end

    it "não é válido sem elemento_form" do
      re = RespostaElem.new(texto_resposta: "Bom", resposta_form: resposta_form)
      expect(re).not_to be_valid
    end

    it "é válido sem campo_form (campo opcional)" do
      re = RespostaElem.new(
        texto_resposta: "Bom",
        resposta_form: resposta_form,
        elemento_form: elemento_form,
        campo_form: nil
      )
      expect(re).to be_valid
    end
  end

  context "associações" do
    it "possui associação com resposta_form" do
      expect(RespostaElem.new).to respond_to(:resposta_form)
    end

    it "possui associação com elemento_form" do
      expect(RespostaElem.new).to respond_to(:elemento_form)
    end

    it "possui associação com campo_form" do
      expect(RespostaElem.new).to respond_to(:campo_form)
    end
  end
end
