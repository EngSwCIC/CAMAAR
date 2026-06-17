class CreateDepartamentos < ActiveRecord::Migration[8.1]
  def change
    create_table :departamentos do |t|
      t.string :nome, limit: 120, null: false

      t.timestamps
    end

    add_index :departamentos, :nome, unique: true
  end
end
