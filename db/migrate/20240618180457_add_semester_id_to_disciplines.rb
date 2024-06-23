class AddSemesterIdToDisciplines < ActiveRecord::Migration[6.0]
  def change
    add_column :disciplines, :semester_id, :integer
  end
end