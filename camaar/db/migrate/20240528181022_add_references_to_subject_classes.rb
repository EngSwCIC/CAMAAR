class AddReferencesToSubjectClasses < ActiveRecord::Migration[7.1]
  def change
    add_reference :subject_classes, :department, null: false, foreign_key: true
    add_reference :subject_classes, :teacher, null: false, foreign_key: true
  end
end
