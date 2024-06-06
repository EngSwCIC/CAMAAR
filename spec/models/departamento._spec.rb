# spec/models/departamento_spec.rb
require 'rails_helper'

RSpec.describe Departamento, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
        departamento = build(:departamento)
        expect(departamento).to be_valid
      end
  end

  describe 'associations' do
    # Adicione seus testes de associações aqui
  end

  describe 'methods' do
    # Adicione seus testes de métodos personalizados aqui
  end
end
