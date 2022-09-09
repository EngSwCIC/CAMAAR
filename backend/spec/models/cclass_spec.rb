require 'rails_helper'

RSpec.describe Cclass, type: :model do
  describe 'factory' do
    context 'when using member factory bot' do
      it { expect(build(:cclass)).to be_valid }
    end
  end
end

