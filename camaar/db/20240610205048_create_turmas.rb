class CreateTurmas < ActiveRecord::Migration[6.1]
  def change
    create_table :turmas do |t|
      t.string :nome_professor, null: false
      t.string :nome_materia, null: false
      t.string :semestre, null: false

      t.timestamps
    end
  end
end
