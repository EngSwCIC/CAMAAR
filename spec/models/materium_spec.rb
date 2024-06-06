require 'rails_helper'

RSpec.describe Materium, type: :model do
  describe 'validations' do
    # Adicione seus testes de validação aqui
  end

  describe 'associations' do
    it { should belong_to(:professors) }
    it { should have_many(:professors) }
    it { should belong_to(:departamento) }
    it { should have_many(:alunos) }    
  end

  describe 'methods' do
    # Adicione seus testes de métodos personalizados aqui
  end
end
