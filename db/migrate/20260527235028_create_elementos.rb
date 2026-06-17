class CreateElementos < ActiveRecord::Migration[8.1]
  def change
    create_table :elementos do |t|
      t.integer :ordem
      t.string :enunciado
      t.references :template, null: false, foreign_key: true

      t.timestamps
    end
  end
end
