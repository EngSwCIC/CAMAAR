class AddReferencesToAnswers < ActiveRecord::Migration[7.1]
  def change
    add_reference :student_answers, :form_question, null: false, foreign_key: true
    add_reference :student_answers, :student, null: false, foreign_key: true

    add_reference :teacher_answers, :form_question, null: false, foreign_key: true
    add_reference :teacher_answers, :teacher, null: false, foreign_key: true
  end
end
