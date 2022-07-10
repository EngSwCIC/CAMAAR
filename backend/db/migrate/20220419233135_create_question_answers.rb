class CreateQuestionAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :question_answers do |t|
      t.text :answer
      t.belongs_to :survey_answer, foreign_key: true
      t.belongs_to :survey_question, foreign_key: true

      t.timestamps
    end
  end
end
