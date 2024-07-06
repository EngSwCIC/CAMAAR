# Migração para adicionar uma coluna booleana isAdmin à tabela users
class AddBoolToUser < ActiveRecord::Migration[7.1]
  ##
  # Adiciona a coluna isAdmin à tabela users
  #
  # +effect_side+ Adiciona uma nova coluna booleana chamada isAdmin à tabela users com o valor padrão de false
  def change
    add_column :users, :isAdmin, :boolean, default: false
  end
end
