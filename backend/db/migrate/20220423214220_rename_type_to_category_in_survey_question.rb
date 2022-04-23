class RenameTypeToCategoryInSurveyQuestion < ActiveRecord::Migration[7.0]
  def change
    rename_column :survey_questions, :type, :category
  end
end
