class AddAlternativesToTemplateQuestions < ActiveRecord::Migration[7.1]
  def change
    add_column :template_questions, :alternatives, :text
  end
end
