require 'rails_helper'

RSpec.describe Departamento, type: :model do
  describe 'validations' do
    context 'is valid with valid attributes' do
      it 'should be valid with valid attributes' do
        departamento = build(:departamento)
        expect(departamento).to be_valid
      end
    end

    context 'is not valid with non-unique nome' do
      it 'should be invalid with a duplicate nome' do
        create(:departamento, nome: 'CIC')
        duplicate_departamento = build(:departamento, nome: 'CIC')
        expect(duplicate_departamento).not_to be_valid
      end
    end
  end
end
