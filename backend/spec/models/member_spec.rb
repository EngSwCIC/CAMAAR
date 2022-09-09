require 'rails_helper'

RSpec.describe Member, type: :model do
  describe 'factory' do
    context 'when using member factory bot' do
      it { expect(build(:member)).to be_valid }
    end
  end
end
