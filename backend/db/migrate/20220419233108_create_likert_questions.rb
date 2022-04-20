class CreateLikertQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :likert_questions do |t|
      t.text :question
      t.belongs_to :likert_scale, foreign_key: true

      t.timestamps
    end
  end
end
