class CreateTeachers < ActiveRecord::Migration[7.1]
  def change
    create_table :teachers do |t|
      t.integer :registration
      t.string :name
      t.string :formation
      t.string :occupation
      t.string :email

      t.timestamps
    end
    add_index :teachers, :email, unique: true
    add_index :teachers, :registration, unique: true

  end
end
