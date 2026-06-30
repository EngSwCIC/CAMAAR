require 'rails_helper'

RSpec.describe Disciplina, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      disc = Disciplina.new(codigo: 'CIC0004', nome: 'Algoritmos e Programação de Computadores')
      expect(disc).to be_valid
    end

    it 'is invalid without a codigo' do
      disc = Disciplina.new(codigo: nil, nome: 'Algoritmos e Programação de Computadores')
      expect(disc).not_to be_valid
      expect(disc.errors[:codigo]).to be_present
    end

    it 'is invalid without a nome' do
      disc = Disciplina.new(codigo: 'CIC0004', nome: nil)
      expect(disc).not_to be_valid
      expect(disc.errors[:nome]).to be_present
    end

    it 'is invalid with a duplicate codigo' do
      Disciplina.create!(codigo: 'CIC0004', nome: 'Algoritmos e Programação de Computadores')
      duplicate_disc = Disciplina.new(codigo: 'CIC0004', nome: 'Estruturas de Dados')
      expect(duplicate_disc).not_to be_valid
      expect(duplicate_disc.errors[:codigo]).to be_present
    end
  end

  describe '#departamento' do
    let!(:dcc) { Departamento.create!(nome: 'DEPTO CIÊNCIAS DA COMPUTAÇÃO') }
    let!(:mat) { Departamento.create!(nome: 'DEPTO MATEMÁTICA') }
    let!(:disc) { Disciplina.create!(codigo: 'CIC0004', nome: 'Algoritmos e Programação de Computadores') }

    it 'returns the first departamento if the discipline has no turmas' do
      expect(disc.departamento).to eq(dcc)
    end

    it 'returns the departamento of the first associated turma' do
      Turma.create!(
        codigo_turma: 'Turma A',
        semestre: '2023.2',
        disciplina: disc,
        departamento: mat
      )
      expect(disc.departamento).to eq(mat)
    end
  end
end
