require 'rails_helper'

RSpec.describe Materia, type: :model do
  describe 'validations' do

    context 'is valid with valid attributes' do
      it 'should be valid with valid attributes' do
        create(:departamento, id: 1, nome: "CIC")
        materia = build(:materia, departamento_id:1)
        expect(materia).to be_valid
      end
    end

    context 'is not valid without a nome' do
        it 'should be invalid without nome' do
          materia = build(:materia, nome: nil, departamento_id:1)
          expect(materia).not_to be_valid
        end
      end

    context 'is not valid without a codigo' do
        it 'should be invalid without codigo' do
          materia = build(:materia, codigo: nil, departamento_id:1)
          expect(materia).not_to be_valid
        end
      end

      context 'is not valid without a semestre' do
        it 'should be invalid without semestre' do
          materia = build(:materia, semestre: nil, departamento_id:1)
          expect(materia).not_to be_valid
        end
      end

      context 'is not valid without a horario' do
        it 'should be invalid without horario' do
          materia = build(:materia, horario: nil, departamento_id:1)
          expect(materia).not_to be_valid
        end
      end

      context 'is not valid without a departamento_id' do
        it 'should be invalid without departamento_id' do
          materia = build(:materia, departamento_id: nil)
          expect(materia).not_to be_valid
        end
      end

  end
end
