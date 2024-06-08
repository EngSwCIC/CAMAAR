require 'rails_helper'

RSpec.describe Aluno, type: :model do
  describe 'validations' do
    context 'is valid with valid attributes' do
      it 'should be valid with valid attributes' do
        aluno = build(:aluno)
        expect(aluno).to be_valid
      end
    end

    context 'is not valid without a nome' do
      it 'should be invalid without nome' do
        aluno = build(:aluno, nome: nil)
        expect(aluno).not_to be_valid
      end
    end

    context 'is not valid without a matricula' do
      it 'should be invalid without matricula' do
        aluno = build(:aluno, matricula: nil)
        expect(aluno).not_to be_valid
      end
    end

    context 'is not valid without an email' do
      it 'should be invalid without email' do
        aluno = build(:aluno, email: nil)
        expect(aluno).not_to be_valid
      end
    end

    context 'is not valid without a password' do
      it 'should be invalid without password' do
        aluno = build(:aluno, encrypted_password: nil)
        expect(aluno).not_to be_valid
      end
    end

    context 'is not valid without a curso' do
      it 'should be invalid without curso' do
        aluno = build(:aluno, curso: nil)
        expect(aluno).not_to be_valid
      end
    end

    context 'is not valid with non-unique matricula' do
      it 'should be invalid with a duplicate matricula' do
        create(:aluno, matricula: '123456')
        duplicate_aluno = build(:aluno, matricula: '123456')
        expect(duplicate_aluno).not_to be_valid
      end
    end

    context 'is not valid with non-unique email' do
      it 'should be invalid with a duplicate email' do
        create(:aluno, email: 'aluno@gmail.com')
        duplicate_aluno = build(:aluno, email: 'aluno@gmail.com')
        expect(duplicate_aluno).not_to be_valid
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:materia) }
  end

end
