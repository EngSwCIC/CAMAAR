class CreateElementoForms < ActiveRecord::Migration[8.1]
  def change
    create_table :elemento_forms do |t|
      t.integer :ordem
      t.string :enunciado
      t.references :formulario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
