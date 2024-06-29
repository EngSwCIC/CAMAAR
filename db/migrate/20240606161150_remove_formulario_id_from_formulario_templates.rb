class RemoveFormularioIdFromFormularioTemplates < ActiveRecord::Migration[7.1]
  def change
    remove_column :formulario_templates, :formulario_id, :integer
  end
end
