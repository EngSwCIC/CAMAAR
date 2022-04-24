class AddColumnSurveyAnswerIdToAnswer < ActiveRecord::Migration[7.0]
  def change
    add_reference :answers, :survey_answers, null: false
  end
end
