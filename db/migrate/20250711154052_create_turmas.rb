class CreateTurmas < ActiveRecord::Migration[8.0]
  def change
    create_table :turmas do |t|
      t.references :disciplina, null: false, foreign_key: true
      t.references :professor, null: false, foreign_key: true
      t.string :semestre

      t.timestamps
    end
  end
end
