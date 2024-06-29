class AddFormularioUsadoToFormularios < ActiveRecord::Migration[7.1]
  def change
    add_reference :formularios, :formulario_templates, null: false, foreign_key: true
  end
end
