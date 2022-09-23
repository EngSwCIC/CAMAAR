class AddGradeToEnrollment < ActiveRecord::Migration[7.0]
  def change
    add_column :enrollments, :grade, :integer
  end
end
