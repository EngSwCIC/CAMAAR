class AddReferencesToQuestions < ActiveRecord::Migration[7.1]
  def change
    # add_reference :forms, :template, null: true, foreign_key: true
    add_reference :form_questions, :form, null: false, foreign_key: true
    add_reference :template_questions, :template, null: false, foreign_key: true
  end
end
