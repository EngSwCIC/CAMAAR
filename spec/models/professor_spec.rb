require 'rails_helper'

RSpec.describe Professor, type: :model do
  describe 'validations' do
    context 'is valid with valid attributes' do
      it 'should be valid with valid attributes' do
        professor = build(:professor)
        expect(professor).to be_valid
      end
    end

    context 'is not valid without a nome' do
      it 'should be invalid without nome' do
        professor = build(:professor, nome: nil)
        expect(professor).not_to be_valid
      end
    end

    context 'is not valid without an email' do
      it 'should be invalid without email' do
        professor = build(:professor, email: nil)
        expect(professor).not_to be_valid
      end
    end

    context 'is not valid without a password' do
      it 'should be invalid without password' do
        professor = build(:professor, encrypted_password: nil)
        expect(professor).not_to be_valid
      end
    end

    context 'is not valid without a is_admin' do
      it 'should be invalid without is_admin' do
        professor = build(:professor, is_admin: nil)
        expect(professor).not_to be_valid
      end
    end

    context 'is not valid with non-unique email' do
      it 'should be invalid with a duplicate email' do
        create(:professor, email: 'professor@gmail.com')
        duplicate_professor = build(:professor, email: 'professor@gmail.com')
        expect(duplicate_professor).not_to be_valid
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:materia) }
    it { should belong_to(:departamento) }

  end
end

