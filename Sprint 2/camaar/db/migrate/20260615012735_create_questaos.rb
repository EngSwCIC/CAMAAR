class CreateQuestaos < ActiveRecord::Migration[7.1]
  def change
    create_table :questaos do |t|
      t.string :enunciado
      t.references :template, null: false, foreign_key: true

      t.timestamps
    end
  end
end
