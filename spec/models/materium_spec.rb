require 'rails_helper'

RSpec.describe Materium, type: :model do
  describe 'validations' do

    context 'is valid with valid attributes' do
      it 'should be valid with valid attributes' do
        create(:departamento, id: 1, nome: "CIC")
        materium = build(:materium, departamento_id:1)
        expect(materium).to be_valid
      end
    end

    context 'is not valid without a nome' do
        it 'should be invalid without nome' do
          materium = build(:materium, nome: nil, departamento_id:1)
          expect(materium).not_to be_valid
        end
      end

    context 'is not valid without a codigo' do
        it 'should be invalid without codigo' do
          materium = build(:materium, codigo: nil, departamento_id:1)
          expect(materium).not_to be_valid
        end
      end

      context 'is not valid without a semestre' do
        it 'should be invalid without semestre' do
          materium = build(:materium, semestre: nil, departamento_id:1)
          expect(materium).not_to be_valid
        end
      end

      context 'is not valid without a horario' do
        it 'should be invalid without horario' do
          materium = build(:materium, horario: nil, departamento_id:1)
          expect(materium).not_to be_valid
        end
      end

      context 'is not valid without a departamento_id' do
        it 'should be invalid without departamento_id' do
          materium = build(:materium, departamento_id: nil)
          expect(materium).not_to be_valid
        end
      end

  end
end
