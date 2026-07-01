class CreateCursos < ActiveRecord::Migration[8.1]
  def change
    create_table :cursos do |t|
      t.string :codigo
      t.string :nome
      t.references :departamento, null: false, foreign_key: true

      t.timestamps
    end
    add_index :cursos, :codigo, unique: true
  end
end
