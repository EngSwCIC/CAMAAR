class AddReferencesToEnrollments < ActiveRecord::Migration[7.1]
  def change
    add_reference :enrollments, :student, null: false, foreign_key: true
    add_reference :enrollments, :subject_class, null: false, foreign_key: true
  end
end
