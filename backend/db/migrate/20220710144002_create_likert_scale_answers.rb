class CreateLikertScaleAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :likert_scale_answers do |t|
      t.integer :answer
      t.belongs_to :likert_scale_question, foreign_key: true, type: :bigint
      t.belongs_to :question_answer, foreign_key: true, type: :bigint
      t.timestamps
    end
  end
end
