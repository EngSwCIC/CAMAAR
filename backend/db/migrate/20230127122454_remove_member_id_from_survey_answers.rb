class RemoveMemberIdFromSurveyAnswers < ActiveRecord::Migration[7.0]
  def change
    # remove_reference :survey_answers, :member_id, null: false, foreign_key: true
    remove_column :survey_answers, :member_id
  end
end
