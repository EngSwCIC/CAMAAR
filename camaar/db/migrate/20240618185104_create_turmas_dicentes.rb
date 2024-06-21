class CreateTurmasDicentes < ActiveRecord::Migration[7.1]
  def change
    create_table :turmas_dicentes do |t|
      t.references :turma, null: false, foreign_key: true
      t.references :dicente, null: false, foreign_key: true

      t.timestamps
    end
  end
end
