# Migração para adicionar uma coluna de departamento à tabela users
class AddDepartamentoUser < ActiveRecord::Migration[7.1]
  ##
  # Adiciona uma coluna de departamento à tabela users
  #
  # +effect_side+ Adiciona uma nova coluna chamada departamento do tipo string à tabela users. Esta coluna tem um valor padrão de string vazia e não permite valores nulos.
  def change
    add_column :users, :departamento, :string, default: '', null: false
  end
end
