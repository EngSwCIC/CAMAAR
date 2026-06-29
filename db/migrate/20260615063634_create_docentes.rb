class CreateDocentes < ActiveRecord::Migration[8.1]
  def change
    create_table :docentes do |t|
      t.string :nome
      t.string :departamento
      t.string :usuario
      t.string :formacao
      t.string :ocupacao
      t.string :email
      t.references :turma, null: false, foreign_key: true

      t.timestamps
    end
  end
end
