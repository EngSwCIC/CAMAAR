class CreateTurmaUserJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_table :turmas_users, id: false do |t|
      t.belongs_to :turma
      t.belongs_to :user
    end
  end
end
