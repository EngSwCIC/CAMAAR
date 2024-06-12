class CreateDicentes < ActiveRecord::Migration[7.1]
  def change
    create_table :dicentes do |t|
      t.string :matricula, null: false
      t.string :curso, null: false
      t.string :turma, array: true, default: []
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
