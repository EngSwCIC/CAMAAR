class CreateAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :answers do |t|
      t.text :content
      t.belongs_to :survey_answer, foreign_key: true
      t.belongs_to :survey_question, foreign_key: true

      t.timestamps
    end
  end
end
