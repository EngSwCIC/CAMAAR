require 'rails_helper'

RSpec.describe Template, type: :model do
  describe 'Validações de Domínio' do
    it 'invalida o registro sem um título' do
      template = Template.new(titulo: nil)
      expect(template).not_to be_valid
    end

    it 'invalida o registro sem questões associadas' do
      template = Template.new(titulo: "Estruturas de Dados")
      expect(template).not_to be_valid
      expect(template.errors[:base]).to include("O template requer no mínimo uma questão associada.")
    end

    it 'invalida a deleção caso existam avaliações vinculadas' do
      template = Template.new(titulo: "Matemática")
      template.questoes.build(enunciado: "Equação")
      template.save!
      
      # Cria a disciplina genérica e depois a turma, 
      # satisfazendo a regra de chave estrangeira do banco de dados.
      disciplina_generica = Disciplina.new
      disciplina_generica.save(validate: false)
      
      turma_generica = Turma.new(disciplina: disciplina_generica)
      turma_generica.save(validate: false)
      
      avaliacao = Avaliacao.new(template: template, turma: turma_generica, data_inicio: Date.today, data_fim: Date.tomorrow)
      avaliacao.save(validate: false)
      
      expect(template.destroy).to be_falsey
      expect(template.errors.empty?).to be_falsey
    end
  end
end