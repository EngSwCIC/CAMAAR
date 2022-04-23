require 'rails_helper'

RSpec.describe Subject, :type => :model do

  describe '.validation' do

    context 'when all attributes is valid' do
      before { described_class.create!(code: 'mat123457', name: 'Algebra') }
      subject = described_class.new(code: 'mat123456', name: 'Cálculo')
      it {expect(subject).to be_valid}
    end

    context 'when name is not unique' do
      before { described_class.create!(code: 'mat123457', name: 'Cálculo') }
      subject = described_class.new(code: 'mat123456', name: 'Cálculo')
      it {expect(subject).to be_invalid}
    end

    context 'when code is not unique' do
      before { described_class.create!(code: 'mat123456', name: 'Algebra')}
      subject = described_class.new(code: 'mat123456', name: 'Cálculo')
      it {expect(subject).to be_invalid}
    end

    context 'when name is null' do
      subject = described_class.new(code: nil, name: 'Cálculo')
      it {expect(subject).to be_invalid}
    end

    context 'when code is null' do
      subject = described_class.new(code: 'mat123456', name: nil)
      it {expect(subject).to be_invalid}
    end
    
  end
end
