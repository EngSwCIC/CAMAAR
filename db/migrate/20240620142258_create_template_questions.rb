class CreateTemplateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :template_questions do |t|
      t.string :title
      t.string :type
      t.string :content

      t.timestamps
    end
  end
end
