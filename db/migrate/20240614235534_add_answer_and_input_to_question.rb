class AddAnswerAndInputToQuestion < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :answer, :string
    add_column :questions, :input, :string
  end
end
