class CreateDepartments < ActiveRecord::Migration[7.1]
  def change
    create_table :departments do |t|
      t.text :name
      t.string :initials

      t.timestamps
    end
  end
end
