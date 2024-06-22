class CreateDepartments < ActiveRecord::Migration[7.1]
  def change
    create_table :departments do |t|
      t.string :name
      t.string :initials

      t.timestamps
    end
    add_index :departments, :initials, unique: true
  end
end
