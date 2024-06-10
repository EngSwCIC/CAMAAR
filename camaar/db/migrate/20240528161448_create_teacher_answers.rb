class CreateTeacherAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :teacher_answers do |t|
      t.integer :question_type
      t.json :answers

      t.timestamps
    end
  end
end
