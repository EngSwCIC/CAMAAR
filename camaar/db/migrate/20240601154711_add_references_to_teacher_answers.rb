class AddReferencesToTeacherAnswers < ActiveRecord::Migration[7.1]
  def change
    add_reference :teacher_answers, :form, null: false, foreign_key: true
    add_reference :teacher_answers, :teacher, null: false, foreign_key: true
  end
end
