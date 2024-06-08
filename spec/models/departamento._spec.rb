require 'rails_helper'

RSpec.describe Departamento, type: :model do
  describe 'validations' do

    context 'is valid with valid attributes' do
      it 'should be valid with valid attributes' do
        departamento = build(:departamento)
        expect(departamento).to be_valid
      end
    end

    context 'is not valid without a nome' do
      it 'should be invalid without nome' do
        departamento = build(:departamento, nome: nil)
        expect(departamento).not_to be_valid
      end
    end

    describe 'associations' do

      end
    end


end
