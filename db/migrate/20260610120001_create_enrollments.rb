class CreateEnrollments < ActiveRecord::Migration[8.1]
  def change
    create_table :enrollments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :turma, null: false, foreign_key: true
      t.string :role, null: false, default: "discente" # docente / discente

      t.timestamps
    end

    add_index :enrollments, %i[user_id turma_id], unique: true
  end
end
