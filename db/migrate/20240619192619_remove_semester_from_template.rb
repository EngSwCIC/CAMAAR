class RemoveSemesterFromTemplate < ActiveRecord::Migration[7.1]
  def change
    remove_reference :templates, :semester, null: false, foreign_key: true
  end
end
