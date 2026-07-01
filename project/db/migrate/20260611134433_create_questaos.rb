class CreateQuestaos < ActiveRecord::Migration[8.1]
  def change
    create_table :questaos do |t|
      t.text :enunciado
      t.string :tipo
      t.references :template, null: true, foreign_key: true
      t.references :formulario, null: true, foreign_key: true

      t.timestamps
    end
  end
end
