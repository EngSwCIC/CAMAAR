require 'rails_helper'

RSpec.describe Template, type: :model do
  describe "validações" do
    it "é válido com nome" do
      expect(Template.new(nome: "Avaliação")).to be_valid
    end

    it "é inválido sem nome" do
      template = Template.new(nome: nil)
      expect(template).not_to be_valid
      expect(template.errors[:nome]).to be_present
    end
  end

  describe ".search" do
    let!(:disciplina) { Template.create!(nome: "Avaliação de Disciplina") }
    let!(:docente)    { Template.create!(nome: "Avaliação de Docente") }

    it "retorna templates cujo nome contém o termo" do
      expect(Template.search("Disciplina")).to contain_exactly(disciplina)
    end

    it "ignora maiúsculas/minúsculas" do
      expect(Template.search("disciplina")).to contain_exactly(disciplina)
    end

    it "retorna todos quando o termo é vazio" do
      expect(Template.search("")).to contain_exactly(disciplina, docente)
    end
  end

  describe "questões aninhadas" do
    it "cria questões junto do template" do
      template = Template.create!(
        nome: "Com questões",
        questions_attributes: [ { enunciado: "Pergunta 1?", tipo: "discursiva" } ]
      )
      expect(template.questions.count).to eq(1)
    end

    it "ignora questões com enunciado em branco" do
      template = Template.create!(
        nome: "Sem questões reais",
        questions_attributes: [ { enunciado: "", tipo: "discursiva" } ]
      )
      expect(template.questions).to be_empty
    end
  end
end
