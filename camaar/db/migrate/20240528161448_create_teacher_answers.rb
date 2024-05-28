class CreateTeacherAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :teacher_answers do |t|
      t.json :answers

      t.timestamps
    end
  end
end
