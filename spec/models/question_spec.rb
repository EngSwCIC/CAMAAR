require 'rails_helper'

RSpec.describe Question, type: :model do
  describe "#opcoes_lista" do
    it "converte a string de opções em um array limpo, separando por quebra de linha" do
      # Cria uma questão simulando um texto sujo com espaços sobrando e linhas em branco
      questao = Question.new(opcoes: "Opção A \n  Opção B  \n\n Opção C")
      
      # Espera que o método limpe tudo e retorne um array 
      expect(questao.opcoes_lista).to eq(["Opção A", "Opção B", "Opção C"])
    end

    it "retorna um array vazio se não houver opções (nil)" do
      questao = Question.new(opcoes: nil)
      
      expect(questao.opcoes_lista).to eq([])
    end
  end
end