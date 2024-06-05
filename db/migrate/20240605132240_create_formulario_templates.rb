class CreateFormularioTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :formulario_templates do |t|
      t.integer :forms_id

      t.timestamps
    end
  end
end
