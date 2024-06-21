class CreateTurma < ActiveRecord::Migration[7.1]
  def change
    create_table :turmas do |t|
      t.string :class_code, null: false
      t.string :semestre, null: false
      t.string :horario, null: false
      t.string :codigo, null: false

      t.references :disciplina, null: false, foreign_key: true
      t.references :docente, foreign_key: true

      t.timestamps
    end
  end
end
