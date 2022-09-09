require 'rails_helper'

RSpec.describe MemberCclass, type: :model do
  context 'Invalid test' do
     it { expect(build(:member_cclass, grade: 110)).to be_invalid }
     it { expect(build(:member_cclass, member: nil)).to be_invalid }
     it { expect(build(:member_cclass, grade: -1)).to be_invalid }
     it { expect(build(:member_cclass, cclass: nil)).to be_invalid }
  end

  context 'Valid tests' do
    it 'Factory' do
      expect(build(:member_cclass)).to be_valid
    end
    
    it 'No grade' do
      expect(build(:member_cclass, grade: nil)).to be_valid
    end
  end
end
