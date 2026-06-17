class CreateDepartamentos < ActiveRecord::Migration[8.1]
  def change
    create_table :departamentos do |t|
      t.string :codigo
      t.string :nome

      t.timestamps
    end
    add_index :departamentos, :codigo, unique: true
  end
end
