class AddConstraintToAnswer < ActiveRecord::Migration[7.1]
  def change
    add_index :answers, %i[user_id question_id], unique: true
  end
end
