class CreateTurmas < ActiveRecord::Migration[8.1]
  def up
    # Idempotente: se a tabela já existe com o schema da sprint-2 (coluna materia_id), pula.
    # Se existe com o schema antigo (sprint-1), descarta e recria.
    return if table_exists?(:turmas) && column_exists?(:turmas, :materia_id)
    drop_table :turmas if table_exists?(:turmas)
    create_table :turmas do |t|
      t.integer :numero_turma
      t.string :semestre_string
      t.float :nota_turma
      t.references :materia, null: false, foreign_key: true
      t.references :professor, null: false, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :turmas, if_exists: true
  end
end
