class CreateSurveyQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :survey_questions do |t|
      t.string :type
      t.text :question
      t.boolean :optional
      t.references :survey, null: false, foreign_key: true

      t.timestamps
    end
  end
end
