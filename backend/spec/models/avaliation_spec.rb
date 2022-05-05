require 'rails_helper'

RSpec.describe Avaliation, type: :model do
  describe '.validation' do
    let(:subject){Subject.create(
      code: "332788913/2",
      name: "Matéria de Teste"
    )}
    let(:cclass){Cclass.create(
      code: "12334",
      semester:"2020/1",
      time:"2020",
      subject_id: subject.id
    )}
    context 'when all attributes is valid' do
      before { described_class.create!(title: 'Prova1', cclass_id: cclass.id )}
      answer = described_class.new(title: 'Prova2', cclass_id: 1)
      it { expect(answer).to be_valid }
    end
    context 'when cclass is null' do
      answer = described_class.new(title: 'Prova2', cclass_id: nil)
      it { expect(answer).to be_invalid }
    end
  end
end
