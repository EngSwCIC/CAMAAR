class RemoveFormsIdFromFormularioTemplate < ActiveRecord::Migration[7.1]
  def change
    remove_column :formulario_templates, :forms_id, :integer
  end
end
