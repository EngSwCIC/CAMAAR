class RenameTypeColumnInSurveyQuestion < ActiveRecord::Migration[7.0]
  def change
    rename_column :survey_questions, :type, :question_type
  end
end
