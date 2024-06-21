class CreateStudents < ActiveRecord::Migration[7.1]
  def change
    create_table :students do |t|
      t.integer :registration
      t.string :name
      t.string :course
      t.string :formation
      t.string :occupation
      t.string :email

      t.timestamps
    end
    add_index :students, :email, unique: true
    add_index :students, :registration, unique: true
  end
end
