class CreateTemplateFormularios < ActiveRecord::Migration[8.1]
  def change
    create_table :template_formularios do |t|
      t.string :nome_template
      t.references :criador_de_formulario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
