class CreateAlunos < ActiveRecord::Migration[7.1]
  def change
    create_table :alunos do |t|
      t.string :nome
      t.string :curso
      t.string :matricula
      t.string :usuario
      t.string :formacao
      t.string :ocupacao
      t.string :email

      t.timestamps
    end
  end
end
