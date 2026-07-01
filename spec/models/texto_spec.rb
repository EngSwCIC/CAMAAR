# frozen_string_literal: true

require "rails_helper"

RSpec.describe Texto, type: :model do
  let(:questao_discursiva) { Questao.new(enunciado: "Descreva", tipo: :discursiva) }
  let(:questao_objetiva) do
    Questao.new(enunciado: "Escolha", tipo: :objetiva).tap do |questao|
      questao.opcoes.build(numero: 1, texto: "A")
      questao.opcoes.build(numero: 2, texto: "B")
    end
  end

  it "normaliza espaços do texto antes da validação" do
    resposta = Resposta.new(questao: questao_discursiva)
    texto = described_class.new(resposta: resposta, texto: "  comentário  ")

    texto.valid?

    expect(texto.texto).to eq("comentário")
  end

  it "exige conteúdo textual" do
    texto = described_class.new(resposta: Resposta.new(questao: questao_discursiva), texto: " ")

    expect(texto).not_to be_valid
    expect(texto.errors[:texto]).not_to be_empty
  end

  it "aceita resposta de questão discursiva" do
    texto = described_class.new(
      resposta: Resposta.new(questao: questao_discursiva),
      texto: "Comentário"
    )

    expect(texto).to be_valid
  end

  it "rejeita resposta de questão objetiva" do
    texto = described_class.new(
      resposta: Resposta.new(questao: questao_objetiva),
      texto: "Comentário"
    )

    expect(texto).not_to be_valid
    expect(texto.errors[:resposta]).to include("deve pertencer a uma questão discursiva")
  end
end
