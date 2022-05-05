require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe '.validation' do
    let(:member) { Member.create(
      name: "MEmbro de Teste",
      registration: '11221442',
      username: "membro123",
      occupation: "Testador",
      degree: '-',
      course: '-',
      email: 'Testemebro@email.com'
    )}
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
    let(:option) { Option.create(
      description: "Descrição para testar uma opção",
      avaliation_id: avaliation.id
    )}

    context 'when all attributes is valid' do
      before { described_class.create!(alternative_answer: 1, option_id: option.id, member_id: member.id) }
      answer = described_class.new(alternative_answer: 1, option_id: 1, member_id: 1)
      it { expect(answer).to be_valid }
    end
  end
end
