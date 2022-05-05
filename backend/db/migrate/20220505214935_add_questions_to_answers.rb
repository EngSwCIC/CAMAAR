class AddQuestionsToAnswers < ActiveRecord::Migration[7.0]
  def change
    add_reference :answers, :question, foreign_key: true
  end
end
