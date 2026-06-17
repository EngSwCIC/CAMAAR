class CreateClassMemberships < ActiveRecord::Migration[8.1]
  def change
    create_table :class_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course_class, null: false, foreign_key: true
      t.integer :role, null: false, default: 0

      t.timestamps
    end

    add_index :class_memberships, [ :user_id, :course_class_id, :role ], unique: true
  end
end
