class CreateLikertScaleQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :likert_scale_questions do |t|
      t.text :question
      t.integer :question_number
      t.integer :scale_points
      t.belongs_to :survey_question, foreign_key: true
      t.timestamps
    end
  end
end
