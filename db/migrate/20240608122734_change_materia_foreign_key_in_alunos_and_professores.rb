class ChangeMateriaForeignKeyInAlunosAndProfessores < ActiveRecord::Migration[7.1]
  def change
    change_column_null :alunos, :materia_id, true
    change_column_null :professors, :materia_id, true
  end
end
