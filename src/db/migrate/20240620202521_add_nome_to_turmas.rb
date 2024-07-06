# Migração para adicionar uma coluna de nome à tabela turmas
class AddNomeToTurmas < ActiveRecord::Migration[7.1]
  ##
  # Adiciona uma coluna de nome à tabela turmas
  #
  # +effect_side+ Adiciona uma nova coluna chamada nome do tipo string à tabela turmas. Esta coluna será usada para armazenar o nome das turmas.
  def change
    add_column :turmas, :nome, :string
  end
end
