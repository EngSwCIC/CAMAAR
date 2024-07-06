# Migração para criar a tabela formularios
class CreateFormularios < ActiveRecord::Migration[7.1]
  ##
  # Cria a tabela formularios com as colunas id_turma, id_template e referências às tabelas turma e template
  #
  # +effect_side+ Cria a tabela formularios com colunas para armazenar os IDs da turma e do template, além de criar referências estrangeiras para as tabelas turma e template, e timestamps para criação e atualização
  def change
    create_table :formularios do |t|
      t.integer :id_turma
      t.integer :id_template
      
      t.belongs_to :turma, foreign_key: true
      t.belongs_to :template, foreign_key: true

      t.timestamps
    end
  end
end
