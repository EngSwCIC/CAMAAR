class CreateQuestionOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :question_options do |t|
      t.string :option
      t.text :content
      t.belongs_to :survey_question, foreign_key: true

      t.timestamps
    end
  end
end
