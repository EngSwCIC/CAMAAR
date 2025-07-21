class CreateTurmas < ActiveRecord::Migration[8.0]
  def change
    create_table :turmas do |t|
      t.integer :id, primary_key: true
      t.string :semestre
      t.integer :numero_turma
      t.string :professor
      t.string :id_materia

      t.timestamps
    end

    add_foreign_key :turmas, :materias, column: :id_materia, primary_key: :id
  end
end
