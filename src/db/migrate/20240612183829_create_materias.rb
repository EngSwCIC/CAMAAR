# Migração para criar a tabela materias
class CreateMaterias < ActiveRecord::Migration[7.1]
  ##
  # Cria a tabela materias com as colunas code e nome
  #
  # +effect_side+ Cria a tabela materias com colunas para armazenar o código da matéria, nome da matéria, e timestamps para criação e atualização
  def change
    create_table :materias do |t|
      t.string :code
      t.string :nome

      t.timestamps
    end
  end
end
