class RenameColumnsInQuestaos < ActiveRecord::Migration[7.1]
  def change
    rename_column :questaos, :formularios_id, :formulario_id
    rename_column :questaos, :templates_id, :template_id
  end
end
