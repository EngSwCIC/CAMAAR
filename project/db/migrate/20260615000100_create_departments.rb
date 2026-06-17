class CreateDepartments < ActiveRecord::Migration[8.1]
  def change
    create_table :departments do |t|
      t.string :name, null: false
      t.string :code, null: false

      t.timestamps
    end

    add_index :departments, :code, unique: true
  end
end
