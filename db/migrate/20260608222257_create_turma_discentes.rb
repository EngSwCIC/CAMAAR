class CreateTurmaDiscentes < ActiveRecord::Migration[7.1]
  def change
    create_table :turma_discentes do |t|
      t.references :discente, null: false, foreign_key: true
      t.references :turma, null: false, foreign_key: true

      t.timestamps
    end
  end
end
