class CreateDisciplinas < ActiveRecord::Migration[8.1]
  def change
    create_table :disciplinas do |t|
      t.string :codigo
      t.string :nome
      t.references :departamento, null: false, foreign_key: true

      t.timestamps
    end
    add_index :disciplinas, :codigo, unique: true
  end
end
