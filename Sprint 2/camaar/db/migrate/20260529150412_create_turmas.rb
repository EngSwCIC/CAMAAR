class CreateTurmas < ActiveRecord::Migration[7.1]
  def change
    create_table :turmas do |t|
      t.references :disciplina, null: false, foreign_key: true
      t.string :codigo
      t.string :semestre
      t.string :horario

      t.timestamps
    end
  end
end
