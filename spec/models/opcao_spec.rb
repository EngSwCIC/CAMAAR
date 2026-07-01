# frozen_string_literal: true

require "rails_helper"

RSpec.describe Opcao, type: :model do
  let(:questao) do
    Questao.new(
      enunciado: "Como você avalia a disciplina?",
      tipo: :objetiva
    )
  end

  describe "associações" do
    it "pertence a uma questão" do
      association = described_class.reflect_on_association(:questao)

      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe "validações" do
    it "é válida com número, texto e questão" do
      opcao = described_class.new(
        numero: 1,
        texto: "Boa",
        questao: questao
      )

      expect(opcao).to be_valid
    end

    it "exige número" do
      opcao = described_class.new(texto: "Boa", questao: questao)

      expect(opcao).not_to be_valid
      expect(opcao.errors[:numero]).not_to be_empty
    end

    it "exige texto" do
      opcao = described_class.new(numero: 1, questao: questao)

      expect(opcao).not_to be_valid
      expect(opcao.errors[:texto]).not_to be_empty
    end

    it "exige questão" do
      opcao = described_class.new(numero: 1, texto: "Boa")

      expect(opcao).not_to be_valid
      expect(opcao.errors[:questao]).not_to be_empty
    end
  end
end
