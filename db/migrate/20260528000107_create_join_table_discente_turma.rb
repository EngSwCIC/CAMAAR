class CreateJoinTableDiscenteTurma < ActiveRecord::Migration[8.1]
  def change
    create_join_table :discentes, :turmas do |t|
      # t.index [:discente_id, :turma_id]
      # t.index [:turma_id, :discente_id]
    end
  end
end
