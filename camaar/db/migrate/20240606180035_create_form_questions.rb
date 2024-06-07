class CreateFormQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :form_questions do |t|
      t.string :title
      t.integer :question_type
      t.json :body

      t.timestamps
    end
  end
end
