class AddPerfilAlvoToTemplates < ActiveRecord::Migration[8.1]
  def change
    add_column :templates, :perfil_alvo, :string
  end
end
