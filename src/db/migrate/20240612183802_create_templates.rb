# Migração para criar a tabela templates
class CreateTemplates < ActiveRecord::Migration[7.1]
    ##
  # Cria a tabela templates com as colunas nome, semestre, e user_id
  #
  # +effect_side+ Cria a tabela templates com colunas para armazenar o nome do template, semestre, uma referência ao usuário, e timestamps para criação e atualização
  def change
    create_table :templates do |t|
      t.string :nome
      t.string :semestre
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
