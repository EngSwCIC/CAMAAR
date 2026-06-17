class CreateCursos < ActiveRecord::Migration[8.1]
  def change
    create_table :cursos do |t|
      t.string :nome, limit: 150, null: false

      t.timestamps
    end

    add_index :cursos, :nome, unique: true
  end
end
