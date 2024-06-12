class AddIdUsuarioToTemplates < ActiveRecord::Migration[7.1]
  def change
    add_column :templates, :id_usuario, :string
  end
end
