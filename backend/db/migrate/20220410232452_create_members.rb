class CreateMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :members do |t|
      t.string :name, null: false
      t.string :registration, null: false
      t.string :username, null: false
      t.string :occupation, null: false
      t.string :degree, null: false
      t.string :course, null: false
      t.string :email, null: false

      t.timestamps
    end
    add_index :members, :registration, unique: true
  end
end
