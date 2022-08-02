class CreateSurveyQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :survey_questions do |t|
      t.text :question
      t.integer :question_number
      t.boolean :optional, default: false
      t.belongs_to :survey, foreign_key: true, type: :bigint
      t.belongs_to :question_type, foreign_key: true, type: :bigint

      t.timestamps
    end
  end
end
