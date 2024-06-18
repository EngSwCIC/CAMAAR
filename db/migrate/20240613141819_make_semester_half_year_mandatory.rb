class MakeSemesterHalfYearMandatory < ActiveRecord::Migration[7.1]
  def change
    change_column :semesters, :half, :boolean, null: false
    change_column :semesters, :year, :integer, null: false
  end
end
