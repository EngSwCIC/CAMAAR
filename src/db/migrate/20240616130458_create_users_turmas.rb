class CreateUsersTurmas < ActiveRecord::Migration[7.1]
  def change
    create_table :users_turmas do |t|
      t.references :user, null: false, foreign_key: true
      t.references :turma, null: false, foreign_key: true

      t.timestamps
    end
  end
end
