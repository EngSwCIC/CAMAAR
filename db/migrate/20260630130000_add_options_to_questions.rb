class AddOptionsToQuestions < ActiveRecord::Migration[8.1]
  def change
    add_column :questions, :options, :text
  end
end
