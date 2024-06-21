class AddQuestionsToTemplate < ActiveRecord::Migration[7.1]
  def change
    add_reference :template_questions, :template, null: false, foreign_key: true
  end
end
