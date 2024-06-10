require 'rails_helper'

RSpec.describe Resposta, type: :model do
  describe "para que seja válida" do
    # uma questão pode ou não ter uma resposta. Depende se foi marcada como obrigatória.
    it "deve ser válida :)" do
      resposta = create(:resposta)
      expect(resposta).to be_valid
    end

    it "deve pertencer a uma questão" do
      respostaB = build(:resposta, questao: nil)
      expect(respostaB).to_not be_valid
    end

    it "deve pertencer a um formulário" do
      respostaB = build(:resposta, formulario: nil)
      expect(respostaB).to_not be_valid
    end
  end
end
