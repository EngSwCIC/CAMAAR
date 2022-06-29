class CreateSurveyQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :survey_questions do |t|
      t.string :question_type
      t.text :question
      t.boolean :optional, default: false
      t.belongs_to :survey, foreign_key: true
      t.belongs_to :question_type, foreign_key: true

      t.timestamps
    end
  end
end
