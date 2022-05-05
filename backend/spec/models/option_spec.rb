require 'rails_helper'

RSpec.describe Option, type: :model do
  describe '.validation' do
    let(:cclass){Cclass.create(
      code: "12334",
      semester:"2020/1",
      time:"2020",
      subject_id: subject.id
    )}
    let(:subject){Subject.create(
      code: "332788913/2",
      name: "Matéria de Teste"
    )}
    let(:avaliation){Avaliation.create(
      title: "Avaliação",
      cclass_id: cclass.id,
      )}
    context 'when all attributes is valid' do
      before { described_class.create!(description: 'Opção teste', avaliation_id: avaliation.id )}
      option = described_class.new(description: 'Opção teste', avaliation_id: 1)
      it { expect(option).to be_valid }
    end
    context 'when avaliation is null' do
      option = described_class.new(description: 'Prova2', avaliation_id: nil)
      it { expect(option).to be_invalid }
    end
  end
end
