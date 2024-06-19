class RemoveAnswerFromQuestion < ActiveRecord::Migration[7.1]
  def change
    remove_column :questions, :answer, :string
  end
end
