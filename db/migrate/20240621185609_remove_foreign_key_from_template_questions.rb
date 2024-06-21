class RemoveForeignKeyFromTemplateQuestions < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :template_questions, :templates
  end
end
