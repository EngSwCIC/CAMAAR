class CreateFormsTurmas < ActiveRecord::Migration[8.1]
  def change
    create_join_table :forms, :turmas do |t|
      t.index [:form_id, :turma_id], unique: true
      t.index [:turma_id, :form_id]
    end
  end
end
