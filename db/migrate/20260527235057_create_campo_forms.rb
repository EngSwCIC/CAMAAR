class CreateCampoForms < ActiveRecord::Migration[8.1]
  def change
    create_table :campo_forms do |t|
      t.integer :ordem
      t.string :enunciado
      t.references :elemento_form, null: false, foreign_key: true

      t.timestamps
    end
  end
end
