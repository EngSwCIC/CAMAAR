class AddForeignKeyToTemplateQuestionsWithCascade < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :template_questions, :templates, on_delete: :cascade
  end
end
