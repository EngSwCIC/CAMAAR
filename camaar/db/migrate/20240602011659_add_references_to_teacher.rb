class AddReferencesToTeacher < ActiveRecord::Migration[7.1]
  def change
    add_reference :teachers, :department, null: true, foreign_key: true
    add_reference :teachers, :user, null: false, foreign_key: true
  end
end
