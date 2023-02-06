require 'rails_helper'

RSpec.describe Survey, type: :model do
  context 'Invalid test' do
    it { expect(build(:survey, id: -1)).to 
    be_invalid}
    end

    context 'Valid test' do
      it 'Factory' do
        expect(build(:survey)).to be_valid
      end
    end
end