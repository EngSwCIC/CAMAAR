require 'rails_helper'

RSpec.describe Resposta, type: :model do
  describe 'associations' do
    it 'belongs to formulario' do
      assoc = described_class.reflect_on_association(:formulario)
      expect(assoc.macro).to eq :belongs_to
    end

    it 'belongs to usuario' do
      assoc = described_class.reflect_on_association(:usuario)
      expect(assoc.macro).to eq :belongs_to
    end

    it 'has many resposta_itens' do
      assoc = described_class.reflect_on_association(:resposta_itens)
      expect(assoc.macro).to eq :has_many
    end
  end
end
