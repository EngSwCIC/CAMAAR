# Migração para criar a tabela questoes_templates
class CreateQuestoesTemplates < ActiveRecord::Migration[7.1]
  ##
  # Cria a tabela questoes_templates com referências às tabelas questao e template
  #
  # +effect_side+ Cria a tabela questoes_templates com referências estrangeiras para as tabelas questao e template, e timestamps para criação e atualização. As referências são obrigatórias (não podem ser nulas).
  def change
    create_table :questoes_templates do |t|
      t.references :questao, null: false, foreign_key: true
      t.references :template, null: false, foreign_key: true

      t.timestamps
    end
  end
end
