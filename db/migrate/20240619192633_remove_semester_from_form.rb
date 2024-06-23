class RemoveSemesterFromForm < ActiveRecord::Migration[7.1]
  def change
    remove_reference :forms, :semester, null: false, foreign_key: true
  end
end
