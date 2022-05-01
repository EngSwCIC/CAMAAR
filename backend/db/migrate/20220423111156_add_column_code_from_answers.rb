class AddColumnCodeFromAnswers < ActiveRecord::Migration[7.0]
  def change
    add_column :answers, :code, :integer
  end
end
