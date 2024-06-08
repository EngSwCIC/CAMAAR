require 'rails_helper'

RSpec.describe Professor, type: :model do
  describe 'validations' do
    let(:departamento) { create(:departamento, id: 1, nome: "cic") }
    let(:materium) do
      create(:materium, 
        departamento_id: 1,
        id: 1, 
        nome: "tp1", 
        codigo: "123", 
        horario: "08:00", 
        semestre: "2024/1"
      )
    end
    context 'is valid with valid attributes' do
      it 'should be valid with valid attributes' do
        professor = build(:professor, materia_id: 1)
        expect(professor).to be_valid
      end
    end

    context 'is not valid without a nome' do
      it 'should be invalid without nome' do
        professor = build(:professor, nome: nil, materia_id: 1)
        expect(professor).not_to be_valid
      end
    end

    context 'is not valid without an email' do
      it 'should be invalid without email' do
        professor = build(:professor, email: nil, materia_id: 1)
        expect(professor).not_to be_valid
      end
    end

    context 'is not valid without an password' do
      it 'should be invalid without password' do
        professor = build(:professor, encrypted_password: nil, materia_id: 1)
        expect(professor).not_to be_valid
      end
    end

    context 'is not valid without an isadmin' do
      it 'should be invalid without isadmin' do
        professor = build(:professor, isadmin: nil, materia_id: 1)
        expect(professor).not_to be_valid
      end
    end
  end

end
