# Migração para remover a coluna usuario da tabela templates
class RemoveUsuarioTemplate < ActiveRecord::Migration[7.1]
  ##
  # Remove a coluna usuario da tabela templates
  #
  # +effect_side+ Remove a coluna chamada usuario da tabela templates. Esta operação eliminará permanentemente a coluna e seus dados associados.
  def change
    remove_column :templates, :usuario
  end
end
