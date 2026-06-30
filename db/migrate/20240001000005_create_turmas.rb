class CreateTurmas < ActiveRecord::Migration[8.1]
  def change
    create_table :turmas do |t|
      t.string :codigo_turma,    limit: 40, null: false
      t.string :semestre,        limit: 10, null: false
      t.bigint :disciplina_id,             null: false
      t.bigint :departamento_id,           null: false
      t.bigint :docente_id

      t.timestamps
    end

    add_index :turmas, [ :codigo_turma, :semestre ], unique: true
    add_index :turmas, :disciplina_id
    add_index :turmas, :departamento_id
    add_index :turmas, :docente_id

    add_foreign_key :turmas, :disciplinas,   column: :disciplina_id
    add_foreign_key :turmas, :departamentos, column: :departamento_id
    add_foreign_key :turmas, :usuarios,      column: :docente_id
  end
end
