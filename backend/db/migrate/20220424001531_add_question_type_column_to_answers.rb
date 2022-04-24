class AddQuestionTypeColumnToAnswers < ActiveRecord::Migration[7.0]
  def change
    add_column :answers, :question_type, :string
  end
end
