class RemoveFormulariosIdFromFormularioTemplates < ActiveRecord::Migration[7.1]
  def change
    remove_column :formulario_templates, :formularios_id, :integer
  end
end
