class CreateTurmas < ActiveRecord::Migration[7.1]
  def change
    create_table :turmas do |t|
      t.string :codigo
      t.string :materia
      t.string :semestre

      t.timestamps
    end
  end
end
