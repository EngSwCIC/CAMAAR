class CreateTemplateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :template_questions do |t|
      t.string :title
      t.string :question_type
      t.json :body

      t.timestamps
    end
  end
end
