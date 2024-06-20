require 'rails_helper'

RSpec.describe Questao, type: :model do
  describe "para que seja válida" do
    it "deve ser válida :)" do
      questao = create(:questao)
      expect(questao).to be_valid
    end

    it "deve possuir um enunciado" do
      questaoB = build(:questao, texto: nil)
      expect(questaoB).to_not be_valid
    end
  end

  describe "para ter relações válidas" do
    it "deve pertencer a um formulário" do
      questao = Questao.reflect_on_association(:formulario)
      expect(questao.macro).to eq(:belongs_to)
    end

    it "deve pertencer a um template" do
      questao = Questao.reflect_on_association(:template)
      expect(questao.macro).to eq(:belongs_to)
    end

    it "pode ter uma resposta" do
      questao = Questao.reflect_on_association(:resposta)
      expect(questao.macro).to eq(:has_one)
    end
  end
end
