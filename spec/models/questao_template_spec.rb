require 'rails_helper'

RSpec.describe QuestaoTemplate, type: :model do
  describe 'methods' do
    it 'returns enunciado for texto' do
      questao = QuestaoTemplate.new(enunciado: 'Test Question', tipo: 'likert')
      expect(questao.texto).to eq('Test Question')
    end

    it 'allows hash-like access' do
      questao = QuestaoTemplate.new(enunciado: 'Test Question', tipo: 'likert')
      expect(questao["texto"]).to eq('Test Question')
      expect(questao["tipo"]).to eq('likert')
    end
  end
end
