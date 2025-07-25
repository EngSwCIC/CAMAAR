# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Disciplina, type: :model do
  let(:curso) { Curso.create!(nome: 'Test Course') }

  describe 'validations' do
    it 'is valid with valid attributes' do
      disciplina = described_class.new(nome: 'Test Discipline', curso: curso)
      expect(disciplina).to be_valid
    end

    it 'is invalid without a nome' do
      disciplina = described_class.new(curso: curso)
      expect(disciplina).not_to be_valid
    end

    it 'is invalid without a curso' do
      disciplina = described_class.new(nome: 'Test Discipline')
      expect(disciplina).not_to be_valid
    end
  end

  describe 'associations' do
    let(:disciplina) { described_class.create!(nome: 'Test Discipline', curso: curso) }

    it 'belongs to a curso' do
      expect(disciplina.curso).to eq(curso)
    end

    it 'can have many turmas' do
      user = User.create!(name: 'Professor', email: 'prof@example.com', password: 'password', matricula: '67890',
                          role: 'professor')
      turma = Turma.create!(disciplina: disciplina, professor: user, semestre: '2024.1')
      expect(disciplina.turmas.count).to eq(1)
      expect(disciplina.turmas.first).to eq(turma)
    end
  end
end
