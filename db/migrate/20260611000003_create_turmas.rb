class CreateTurmas < ActiveRecord::Migration[8.1]
  def change
    create_table :turmas do |t|
      t.references :departamento, null: false, foreign_key: true
      t.string :codigo, null: false
      t.string :nome, null: false
      
      t.string :turma
      t.string :semestre

      t.timestamps
    end
  end
end
