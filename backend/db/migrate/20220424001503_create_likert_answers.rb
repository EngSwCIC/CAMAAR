class CreateLikertAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :likert_answers do |t|
      t.text :content
      t.belongs_to :answer, foreign_key: true
      t.belongs_to :likert_question, foreign_key: true

      t.timestamps
    end
  end
end
