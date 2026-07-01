class CreateTurmaMemberships < ActiveRecord::Migration[8.1]
  def change
    create_table :turma_memberships do |t|
      t.references :turma, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
    add_index :turma_memberships, [:turma_id, :user_id], unique: true
  end
end
