class RemoveSurveyAnswersIdFromAnswer < ActiveRecord::Migration[7.0]
  def change
    remove_column :answers, :survey_answers_id
  end
end
