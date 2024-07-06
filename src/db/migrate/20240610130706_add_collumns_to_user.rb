# Migração para adicionar várias colunas à tabela users
class AddCollumnsToUser < ActiveRecord::Migration[7.1]
  ##
  # Adiciona várias colunas à tabela users
  #
  # +effect_side+ Adiciona as colunas nome, curso, ocupacao, formacao, matricula e usuario à tabela users. Todas as colunas são do tipo string, com valor padrão vazio ('') e não permitem valores nulos.
  def change
    add_column :users, :nome, :string, default: '', null: false
    add_column :users, :curso, :string, default: '', null: false
    add_column :users, :ocupacao, :string, default: '', null: false
    add_column :users, :formacao, :string, default: '', null: false
    add_column :users, :matricula, :string, default: '', null: false
    add_column :users, :usuario, :string, default: '', null: false
  end
end
