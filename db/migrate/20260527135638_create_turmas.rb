class CreateTurmas < ActiveRecord::Migration[8.1]
  def change
    create_table :turmas do |t|
      t.string :classCode
      t.string :semester
      t.string :time
      t.references :disciplina, null: false, foreign_key: true

      t.timestamps
    end
  end
end
