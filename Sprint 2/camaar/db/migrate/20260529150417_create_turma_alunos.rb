class CreateTurmaAlunos < ActiveRecord::Migration[7.1]
  def change
    create_table :turma_alunos do |t|
      t.references :turma, null: false, foreign_key: true
      t.integer :aluno_id

      t.timestamps
    end
    add_index :turma_alunos, [:turma_id, :aluno_id], unique: true
  end
end
