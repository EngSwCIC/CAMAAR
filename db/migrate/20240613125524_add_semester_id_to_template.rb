class AddSemesterIdToTemplate < ActiveRecord::Migration[7.1]
  def change
    add_reference :templates, :semester, null: false, foreign_key: true
  end
end
