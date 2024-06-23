class SwitchToFormAndTemplateInSemester < ActiveRecord::Migration[7.1]
  def change
    add_reference :semesters, :templates, foreign_key: true
    add_reference :semesters, :forms, foreign_key: true
    remove_reference :semesters, :formlike, polymorphic: true
  end
end
