class CreateMaterias < ActiveRecord::Migration[8.1]
  def change
    create_table :materias do |t|
      t.references :departamento, null: false, foreign_key: true
      t.string :codigo, null: false
      t.string :nome, null: false

      t.timestamps
    end

    add_index :materias, :codigo, unique: true
  end
end
