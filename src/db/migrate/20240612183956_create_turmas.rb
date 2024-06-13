class CreateTurmas < ActiveRecord::Migration[7.1]
  def change
    create_table :turmas do |t|
      t.string :classCode
      t.string :semestre
      t.integer :professor_id
      t.belongs_to :materia, foreign_key: true

      t.timestamps
    end
  end
end
