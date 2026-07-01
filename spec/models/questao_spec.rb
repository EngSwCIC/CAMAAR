# frozen_string_literal: true

require "rails_helper"

RSpec.describe Questao, type: :model do
  describe "associações" do
    it "possui utilizações de questões com restrição de remoção" do
      association =
        described_class.reflect_on_association(:utilizacoes_questoes)

      expect(association.macro).to eq(:has_many)
      expect(association.class_name).to eq("UtilizacaoQuestao")
      expect(association.foreign_key).to eq("questao_id")
      expect(association.options[:dependent]).to eq(:restrict_with_error)
    end

    it "possui opções removidas em cascata" do
      association = described_class.reflect_on_association(:opcoes)

      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe "tipos" do
    it "define os valores do enum" do
      expect(described_class.tipos).to eq(
        "objetiva" => 0,
        "discursiva" => 1
      )
    end
  end

  describe "validações" do
    it "exige enunciado" do
      questao = described_class.new(tipo: :discursiva)

      expect(questao).not_to be_valid
      expect(questao.errors[:enunciado]).not_to be_empty
    end

    it "exige tipo" do
      questao = described_class.new(enunciado: "Questão sem tipo")

      expect(questao).not_to be_valid
      expect(questao.errors[:tipo]).not_to be_empty
    end

    it "permite questão discursiva sem opções" do
      questao = described_class.new(
        enunciado: "Descreva sua experiência",
        tipo: :discursiva
      )

      expect(questao).to be_valid
    end

    it "exige pelo menos duas opções para questão objetiva" do
      questao = described_class.new(
        enunciado: "Como você avalia a disciplina?",
        tipo: :objetiva
      )

      expect(questao).not_to be_valid
      expect(questao.errors[:opcoes])
        .to include("devem ter pelo menos duas alternativas para questão objetiva")
    end

    it "permite questão objetiva com duas opções" do
      questao = described_class.new(
        enunciado: "Como você avalia a disciplina?",
        tipo: :objetiva
      )
      questao.opcoes.build(numero: 1, texto: "Boa")
      questao.opcoes.build(numero: 2, texto: "Excelente")

      expect(questao).to be_valid
    end

    it "ignora opções marcadas para remoção" do
      questao = described_class.new(
        enunciado: "Como você avalia a disciplina?",
        tipo: :objetiva
      )
      opcao = questao.opcoes.build(numero: 1, texto: "Boa")
      opcao.mark_for_destruction

      expect(questao).not_to be_valid
      expect(questao.errors[:opcoes])
        .to include("devem ter pelo menos duas alternativas para questão objetiva")
    end

    it "não permite opções em questão discursiva" do
      questao = described_class.new(
        enunciado: "Descreva sua experiência",
        tipo: :discursiva
      )
      questao.opcoes.build(numero: 1, texto: "Boa")

      expect(questao).not_to be_valid
      expect(questao.errors[:opcoes])
        .to include("não devem existir em questão discursiva")
    end

    it "não permite opções em questão discursiva via atributos aninhados" do
      questao = described_class.new(
        enunciado: "Descreva sua experiência",
        tipo: :discursiva,
        opcoes_attributes: [
          { numero: 1, texto: "Boa" }
        ]
      )

      expect(questao).not_to be_valid
      expect(questao.errors[:opcoes])
        .to include("não devem existir em questão discursiva")
    end

    it "normaliza o enunciado" do
      questao = described_class.new(
        enunciado: "  Descreva sua experiência  ",
        tipo: :discursiva
      )

      questao.valid?

      expect(questao.enunciado).to eq("Descreva sua experiência")
    end
  end
end
