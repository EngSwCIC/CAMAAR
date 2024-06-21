require 'rails_helper'

RSpec.describe Formulario, type: :model do
  describe "para que seja válida" do
    it "deve ser válida :)" do
      formulario = create(:formulario)
      expect(formulario).to be_valid
    end

    it "deve possuir um nome" do
      formularioB = build(:formulario, nome: nil)
      expect(formularioB).to_not be_valid
    end
  end

  describe "para ter relações válidas" do
    it "deve pertencer a uma turma" do
      formulario = Formulario.reflect_on_association(:turma)
      expect(formulario.macro).to eq(:belongs_to)
    end

    it "deve pertencer a um template" do
      formulario = Formulario.reflect_on_association(:template)
      expect(formulario.macro).to eq(:belongs_to)
    end

    it "deve ter uma resposta" do
      formulario = Formulario.reflect_on_association(:respostas)
      expect(formulario.macro).to eq(:has_many)
    end

    it "pode ter várias questões" do
      formulario = Formulario.reflect_on_association(:questaos)
      expect(formulario.macro).to eq(:has_many)
    end
  end
end
