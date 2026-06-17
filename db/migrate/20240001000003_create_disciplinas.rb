class CreateDisciplinas < ActiveRecord::Migration[8.1]
  def change
    create_table :disciplinas do |t|
      t.string :codigo, limit: 30, null: false
      t.string :nome,   limit: 150, null: false

      t.timestamps
    end

    add_index :disciplinas, :codigo, unique: true
  end
end
