# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Curso, type: :model do
  describe 'validations' do
    it 'is valid with a name' do
      curso = described_class.new(nome: 'Engenharia de Software')
      expect(curso).to be_valid
    end

    it 'is invalid without a name' do
      curso = described_class.new
      expect(curso).not_to be_valid
    end
  end

  describe 'associations' do
    let(:curso) { described_class.create!(nome: 'Test Course') }

    it 'can have many disciplinas' do
      disciplina = Disciplina.create!(nome: 'Test Discipline', curso: curso)
      expect(curso.disciplinas.count).to eq(1)
      expect(curso.disciplinas.first).to eq(disciplina)
    end

    it 'destroys associated disciplinas when destroyed' do
      Disciplina.create!(nome: 'Test Discipline', curso: curso)
      expect { curso.destroy }.to change(Disciplina, :count).by(-1)
    end
  end
end
