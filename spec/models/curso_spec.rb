require 'rails_helper'

RSpec.describe Curso, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      curso = Curso.new(nome: 'Ciência da Computação')
      expect(curso).to be_valid
    end

    it 'is invalid without a nome' do
      curso = Curso.new(nome: nil)
      expect(curso).not_to be_valid
      expect(curso.errors[:nome]).to be_present
    end

    it 'is invalid with a duplicate nome' do
      Curso.create!(nome: 'Engenharia de Software')
      duplicate_curso = Curso.new(nome: 'Engenharia de Software')
      expect(duplicate_curso).not_to be_valid
      expect(duplicate_curso.errors[:nome]).to be_present
    end
  end
end
