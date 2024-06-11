class CreateTurmas < ActiveRecord::Migration[7.1]
  def change
    create_table :turmas do |t|
      #t.string :nome_professor, null: false
      t.string :nome_turma, null: false
      t.string :nome_materia, null: false
      t.string :semestre, null: false
      t.jsonb :nomes_alunos, default: []
      t.jsonb :nomes_formularios, default: []
      t.references :administrador, null: false, foreign_key: true

      t.timestamps
    end
  end
end
