# Migração para adicionar um índice único à coluna usuario da tabela users
class DefineUserPk < ActiveRecord::Migration[7.1]
  ##
  # Adiciona um índice único à coluna usuario na tabela users
  #
  # +effect_side+ Garante que os valores na coluna usuario sejam únicos em toda a tabela users, prevenindo duplicatas e melhorando a performance de consultas
  def change
    add_index :users, :usuario, unique: true
  end
end
