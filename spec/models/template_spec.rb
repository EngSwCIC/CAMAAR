# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Template, type: :model do
  let(:user) do
    User.create!(name: 'Test User', email: 'test@example.com', password: 'password', matricula: '12345', role: 'admin')
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      template = described_class.new(
        titulo: 'Test Template',
        publico_alvo: 1,
        criado_por: user
      )
      expect(template).to be_valid
    end

    it 'is invalid without a titulo' do
      template = described_class.new(publico_alvo: 1, criado_por: user)
      expect(template).not_to be_valid
    end

    it 'is invalid without a criado_por' do
      template = described_class.new(titulo: 'Test Template', publico_alvo: 1)
      expect(template).not_to be_valid
    end
  end

  describe 'associations' do
    let(:template) { described_class.create!(titulo: 'Test Template', publico_alvo: 1, criado_por: user) }

    it 'belongs to a criado_por (user)' do
      expect(template.criado_por).to eq(user)
    end

    it 'can have many perguntas' do
      pergunta = Perguntum.create!(template: template, titulo: 'Test Question', tipo: 1, ordem: 1)
      expect(template.pergunta.count).to eq(1)
      expect(template.pergunta.first).to eq(pergunta)
    end
  end
end
