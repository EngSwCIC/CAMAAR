require 'rails_helper'

RSpec.describe RespostaItem, type: :model do
  describe 'associations' do
    it 'belongs to resposta' do
      assoc = described_class.reflect_on_association(:resposta)
      expect(assoc.macro).to eq :belongs_to
    end

    it 'belongs to questao_template' do
      assoc = described_class.reflect_on_association(:questao_template)
      expect(assoc.macro).to eq :belongs_to
    end
  end
end
