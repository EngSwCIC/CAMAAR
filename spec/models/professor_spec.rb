require 'rails_helper'

RSpec.describe Professor, type: :model do
  describe 'validations' do
    context 'is valid with valid attributes' do
      it 'should be valid with valid attributes' do
        create(:departamento, id: 1, nome: "CIC")
        professor = build(:professor,departamento_id:1)
        expect(professor).to be_valid
      end
    end

    context 'is not valid without a nome' do
      it 'should be invalid without nome' do
        professor = build(:professor, nome: nil,departamento_id:1)
        expect(professor).not_to be_valid
      end
    end

    context 'is not valid without a isadmin' do
      it 'should be invalid without isadmin' do
        professor = build(:professor, isadmin: nil,departamento_id:1)
        expect(professor).not_to be_valid
      end
    end

    context 'is not valid without an email' do
      it 'should be invalid without email' do
        professor = build(:professor, email: nil,departamento_id:1)
        expect(professor).not_to be_valid
      end
    end

    context 'is not valid without a password' do
      it 'should be invalid without password' do
        professor = build(:professor, encrypted_password: nil,departamento_id:1)
        expect(professor).not_to be_valid
      end
    end

  end
  
end
