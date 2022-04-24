class AddColumnSurveyAnswerIdToAnswer < ActiveRecord::Migration[7.0]
  def change
    add_reference :answers, :survey_answer, null: false
  end
end
