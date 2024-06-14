class AddAnswerToQuestion < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :answer, :string
  end
end
