class CreateDisciplina < ActiveRecord::Migration[7.1]
  def change
    create_table :disciplinas do |t|
      t.string :codigo, null: false
      t.string :nome, null: false

      t.timestamps
    end
    add_index :disciplinas, :codigo, unique: true
  end
end
