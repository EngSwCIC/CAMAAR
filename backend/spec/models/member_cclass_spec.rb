require 'rails_helper'

RSpec.describe MemberCclass, type: :model do
  context 'Invalid test' do
    it 'Should be invalid when grade > 100' do
       expect(build(:member_cclass, grade: 110)).to be_invalid 
    end
    it 'Should be invalid with no member_id associated' do
       expect(build(:member_cclass, member: nil)).to be_invalid 
    end
    it 'Should be invalid when grade < 0' do
       expect(build(:member_cclass, grade: -1)).to be_invalid 
    end
    it 'Should be invalid with no cclass_id associated' do
       expect(build(:member_cclass, cclass: nil)).to be_invalid 
    end
  end

  context 'Valid tests' do
    it 'Should be valid using Factory bot' do
      expect(build(:member_cclass)).to be_valid
    end
    
    it 'Should be valid with No grade' do
      expect(build(:member_cclass, grade: nil)).to be_valid
    end

    it 'Should be valid with grade 0' do
      expect(build(:member_cclass, grade: 0)).to be_valid
    end

    it 'Should be valid with grade 100' do
      expect(build(:member_cclass, grade: 100)).to be_valid
    end
  end
end
