class AddTemplateIdToSemester < ActiveRecord::Migration[7.1]
  def change
    add_reference :semesters, :template, foreign_key: true
  end
end
