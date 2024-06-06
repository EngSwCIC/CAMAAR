class AddFormularioCriadoToFormularioTemplates < ActiveRecord::Migration[7.1]
  def change
    add_reference :formulario_templates, :formularios, null: false, foreign_key: true
  end
end
