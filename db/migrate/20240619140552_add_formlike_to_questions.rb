class AddFormlikeToQuestions < ActiveRecord::Migration[7.1]
  def change
    add_reference :questions, :formlike, polymorphic: true, null: false
    remove_reference :questions, :template, null: false, foreign_key: true
  end
end
