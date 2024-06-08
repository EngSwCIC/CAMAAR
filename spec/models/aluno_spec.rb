require 'rails_helper'

RSpec.describe Aluno, type: :model do
  describe 'validations' do
    let(:departamento) { create(:departamento, id: 1, nome; "cic") }
    let(:materium) { create(:materium, departamento_id: 1, id: 1, nome: "tp1") }

    context 'is valid with valid attributes' do
      it 'should be valid with valid attributes' do
        aluno = build(:aluno, materia_id: 1)
        expect(aluno).to be_valid
      end
    end

    context 'is not valid without a nome' do
      it 'should be invalid without nome' do
        aluno = build(:aluno, nome: nil, materia_id: 1)
        expect(aluno).not_to be_valid
      end
    end

    context 'is not valid without a matricula' do
      it 'should be invalid without matricula' do
        aluno = build(:aluno, matricula: nil, materia_id: 1)
        expect(aluno).not_to be_valid
      end
    end

    context 'is not valid without an email' do
      it 'should be invalid without email' do
        aluno = build(:aluno, email: nil, materia_id: 1)
        expect(aluno).not_to be_valid
      end
    end

    context 'is not valid without a password' do
      it 'should be invalid without password' do
        aluno = build(:aluno, encrypted_password: nil, materia_id: 1)
        expect(aluno).not_to be_valid
      end
    end

    context 'is not valid without a curso' do
      it 'should be invalid without curso' do
        aluno = build(:aluno, curso: nil, materia_id: 1)
        expect(aluno).not_to be_valid
      end
    end

    context 'is not valid with non-unique matricula' do
      it 'should be invalid with a duplicate matricula' do
        create(:aluno, matricula: '123456', materia_id: 1)
        duplicate_aluno = build(:aluno, matricula: '123456', materia_id: 1)
        expect(duplicate_aluno).not_to be_valid
      end
    end

    context 'is not valid with non-unique email' do
      it 'should be invalid with a duplicate email' do
        create(:aluno, email: 'aluno@gmail.com', materia_id: 1)
        duplicate_aluno = build(:aluno, email: 'aluno@gmail.com', materia_id: 1)
        expect(duplicate_aluno).not_to be_valid
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:materium) }
  end
end
