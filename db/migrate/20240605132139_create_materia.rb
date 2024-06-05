class CreateMateria < ActiveRecord::Migration[7.1]
  def change
    create_table :materia do |t|
      t.integer :código
      t.integer :semestre
      t.string :nome
      t.integer :departamento
      t.integer :professor_id
      t.integer :aluno_id
      t.integer :forms_materia

      t.timestamps
    end
  end
end
