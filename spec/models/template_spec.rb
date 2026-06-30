require 'rails_helper'

RSpec.describe Template, type: :model do
  describe 'validations' do
    it 'is invalid without a titulo' do
      template = Template.new(titulo: nil)
      expect(template).not_to be_valid
      expect(template.errors[:titulo]).to include("Nome do Template não pode ficar em branco")
    end

    it 'is invalid without at least one question' do
      template = Template.new(titulo: 'Valid Title')
      expect(template).not_to be_valid
      expect(template.errors[:base]).to include("O template deve ter ao menos uma pergunta")
    end

    it 'is valid with a title and questions, skipping question validation' do
      criador = Usuario.new(nome: 'Admin', email: 'admin@unb.br', perfil: 'administrador', senha_hash: 'dummy')
      criador.save!(validate: false)
      template = Template.new(titulo: 'Valid Title', criador: criador)
      template.skip_questions_validation = true
      expect(template).to be_valid
    end
  end
end
