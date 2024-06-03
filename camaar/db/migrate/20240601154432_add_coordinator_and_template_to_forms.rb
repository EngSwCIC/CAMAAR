class AddCoordinatorAndTemplateToForms < ActiveRecord::Migration[7.1]
  def change
    add_reference :forms, :template, null: true, foreign_key: true
    add_reference :forms, :coordinator, null: false, foreign_key: true
    add_reference :forms, :subject_class, null: false, foreign_key: true
  end
end
