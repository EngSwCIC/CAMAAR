require 'rails_helper'

RSpec.describe Departamento, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      dep = Departamento.new(nome: 'Ciências da Computação')
      expect(dep).to be_valid
    end

    it 'is invalid without a nome' do
      dep = Departamento.new(nome: nil)
      expect(dep).not_to be_valid
      expect(dep.errors[:nome]).to be_present
    end

    it 'is invalid with a duplicate nome' do
      Departamento.create!(nome: 'Matemática')
      duplicate_dep = Departamento.new(nome: 'Matemática')
      expect(duplicate_dep).not_to be_valid
      expect(duplicate_dep.errors[:nome]).to be_present
    end
  end

  describe '#codigo' do
    it 'returns CIC if name includes COMPUTAÇÃO (case insensitive)' do
      dep = Departamento.new(nome: 'Departamento de Ciência da Computação')
      expect(dep.codigo).to eq('CIC')
    end

    it 'returns an acronym of the first letters if it does not include COMPUTAÇÃO' do
      dep = Departamento.new(nome: 'Departamento Matemática')
      expect(dep.codigo).to eq('DM')
    end

    it 'limits the acronym to 5 characters' do
      dep = Departamento.new(nome: 'A B C D E F G')
      expect(dep.codigo).to eq('ABCDE')
    end
  end
end
