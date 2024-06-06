require 'rails_helper'

RSpec.describe Departamento, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
        departamento = build(:departamento)
        expect(departamento).to be_valid
      end
  end
  

  describe 'associations' do
    it { should have_many(:materias) }
    it { should have_many(:professor) }
  end

  describe 'methods' do
    # Adicione seus testes de métodos personalizados aqui
  end
end
