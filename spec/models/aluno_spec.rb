require 'rails_helper'

RSpec.describe Aluno, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
        Aluno = build(:Aluno)
        expect(Aluno).to be_valid
      end
  end

  describe 'associations' do
    it { should have_many(:materias) }
  end

  describe 'methods' do
    # Adicione seus testes de métodos personalizados aqui
  end
end