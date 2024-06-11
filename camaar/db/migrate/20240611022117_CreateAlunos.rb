class CreateAlunos < ActiveRecord::Migration[7.1]
  def change
    create_table :alunos do |t|
      t.matricula :senha, null: false
      t.references :user, null: false, foreign_key: true
      t.references :turma, null: false, foreign_key: true

      t.timestamps
    end
  end
end
