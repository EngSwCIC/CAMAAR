# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Formulario, type: :model do
  let(:user) do
    User.create!(name: 'Test User', email: 'test@example.com', password: 'password', matricula: '12345', role: 'admin')
  end
  let(:curso) { Curso.create!(nome: 'Test Course') }
  let(:disciplina) { Disciplina.create!(nome: 'Test Discipline', curso: curso) }
  let(:professor) do
    User.create!(name: 'Professor', email: 'prof@example.com', password: 'password', matricula: '67890',
                 role: 'professor')
  end
  let(:turma) { Turma.create!(disciplina: disciplina, professor: professor, semestre: '2024.1') }
  let(:template) { Template.create!(titulo: 'Test Template', publico_alvo: 1, criado_por: user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      formulario = described_class.new(
        template: template,
        turma: turma,
        coordenador: user,
        data_envio: Time.current,
        data_fim: 1.week.from_now
      )
      expect(formulario).to be_valid
    end

    it 'is invalid without a template' do
      formulario = described_class.new(turma: turma, coordenador: user)
      expect(formulario).not_to be_valid
    end

    it 'is invalid without a turma' do
      formulario = described_class.new(template: template, coordenador: user)
      expect(formulario).not_to be_valid
    end

    it 'is invalid without a coordenador' do
      formulario = described_class.new(template: template, turma: turma)
      expect(formulario).not_to be_valid
    end
  end

  describe 'associations' do
    let(:formulario) { described_class.create!(template: template, turma: turma, coordenador: user) }

    it 'belongs to a template' do
      expect(formulario.template).to eq(template)
    end

    it 'belongs to a turma' do
      expect(formulario.turma).to eq(turma)
    end

    it 'belongs to a coordenador (user)' do
      expect(formulario.coordenador).to eq(user)
    end
  end
end
