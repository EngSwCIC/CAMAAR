class AddNameToFormularioTemplates < ActiveRecord::Migration[7.1]
  def change
    add_column :formulario_templates, :name, :string
  end
end
