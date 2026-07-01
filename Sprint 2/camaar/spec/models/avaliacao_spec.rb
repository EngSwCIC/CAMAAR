require 'rails_helper'

RSpec.describe Avaliacao, type: :model do
  describe 'Validações de Domínio' do
    it 'invalida o registro sem um template associado' do
      avaliacao = Avaliacao.new(data_inicio: Date.today, data_fim: Date.tomorrow)
      expect(avaliacao).not_to be_valid
    end

    it 'invalida o registro se a data de fim for anterior à data de início' do
      # Usa .new e .build para montar na memória juntos
      template = Template.new(titulo: "Padrão")
      template.questoes.build(enunciado: "Q1")
      template.save!
      
      avaliacao = Avaliacao.new(template: template, data_inicio: Date.tomorrow, data_fim: Date.today)
      expect(avaliacao).not_to be_valid
      expect(avaliacao.errors[:data_fim]).to include("deve ser posterior à data de início")
    end
  end
end