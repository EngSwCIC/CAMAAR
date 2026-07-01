require 'rails_helper'

RSpec.describe TemplateQuestao, type: :model do
  before(:each) do
    @pessoa = Pessoa.create!(usuario: 'casemiro', nome: 'Casemiro', email: 'casemiro@unb.br', password: '123', password_confirmation: '123')
    @template = Template.create!(nome: 'Avaliação de Bancos de Dados', pessoa: @pessoa)
  end

  describe 'Criação e Validações' do
    context 'Happy Path' do
      it 'cria uma questão de template válida' do
        questao = TemplateQuestao.new(
          template: @template,
          enunciado: 'Explique a diferença conceitual entre SQL e NoSQL.',
          tipo_resposta: :texto
        )
        
        expect(questao).to be_valid
        expect(questao.save).to be true
        expect(questao.texto?).to be true
      end
    end

    context 'Sad Path' do
      it 'é inválida sem um template associado' do
        questao = TemplateQuestao.new(
          enunciado: 'Qual a sua nota para a didática do professor?',
          tipo_resposta: :radio
        )
        
        expect(questao).not_to be_valid
        expect(questao.errors[:template]).to be_present
      end
    end
  end
end