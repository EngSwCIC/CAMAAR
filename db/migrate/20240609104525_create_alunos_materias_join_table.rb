class CreateAlunosMateriasJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_table :alunos_materias, id: false do |t|
      t.references :aluno, null: false, foreign_key: true
      t.references :materia, null: false, foreign_key: true
    end

    add_index :alunos_materias, [:aluno_id, :materia_id], unique: true
    add_index :alunos_materias, [:materia_id, :aluno_id], unique: true

   
    remove_reference :materia, :alunos, foreign_key: true if column_exists?(:materia, :alunos_id)
    remove_reference :alunos, :materia, foreign_key: true if column_exists?(:alunos, :materia_id)
  end
end
