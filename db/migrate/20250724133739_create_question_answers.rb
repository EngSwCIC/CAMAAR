class CreateQuestionAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :question_answers do |t|
      t.references :template_response, null: false, foreign_key: true
      t.references :template_question, null: false, foreign_key: true
      t.text :answer_text
      t.timestamps
    end

    add_index :question_answers, [ :template_response_id, :template_question_id ],
              unique: true, name: 'index_answers_on_response_and_question'
  end
end
