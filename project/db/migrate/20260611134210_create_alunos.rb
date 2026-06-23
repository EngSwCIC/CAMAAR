class CreateAlunos < ActiveRecord::Migration[8.1]
  def change
    create_table :alunos do |t|
      t.string :matricula
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :course

      t.timestamps
    end
  end
end
