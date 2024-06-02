class CreateEnrollments < ActiveRecord::Migration[7.1]
  def change
    create_table :enrollments do |t|
      t.integer :student_id
      t.integer :subject_class_id
      t.timestamps
    end
  end
end
