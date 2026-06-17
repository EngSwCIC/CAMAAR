class CreateTurmas < ActiveRecord::Migration[8.1]
  def change
    create_table :turmas do |t|
      t.string :numero_da_turma
      t.string :semestre
      t.string :horario
      t.references :disciplina, null: false, foreign_key: true

      t.timestamps
    end
  end
end
