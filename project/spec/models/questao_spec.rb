require "rails_helper"

RSpec.describe Questao, type: :model do
  describe "validações" do
    it "é válida com os atributos da factory" do
      expect(build(:questao)).to be_valid
    end

    it "exige um enunciado" do
      questao = build(:questao, enunciado: nil)

      expect(questao).not_to be_valid
      expect(questao.errors[:enunciado]).to include("can't be blank")
    end
  end

  describe "associações" do
    it "pode pertencer a um template (questão de um template, #102)" do
      template = create(:template)
      questao = create(:questao, template: template)

      expect(questao.template).to eq(template)
      expect(questao.formulario_id).to be_nil
    end

    it "pode pertencer a um formulário sem template (questão clonada, #103)" do
      questao = create(:questao, :de_formulario)

      expect(questao.template_id).to be_nil
      expect(questao.formulario).to be_present
    end

    it "é válida sem template e sem formulário associados" do
      questao = build(:questao, template: nil, formulario: nil)

      expect(questao).to be_valid
    end
  end
end
