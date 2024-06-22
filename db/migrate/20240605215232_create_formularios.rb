class CreateFormularios < ActiveRecord::Migration[7.1]
  def change
    create_table :formularios do |t|
      t.integer :template_usado
      t.text :perguntas

      t.timestamps
    end
  end
end
