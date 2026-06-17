class CreateJoinTableDocenteTurma < ActiveRecord::Migration[8.1]
  def change
    create_join_table :docentes, :turmas do |t|
      # t.index [:docente_id, :turma_id]
      # t.index [:turma_id, :docente_id]
    end
  end
end
