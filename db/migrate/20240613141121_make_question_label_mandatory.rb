class MakeQuestionLabelMandatory < ActiveRecord::Migration[7.1]
  def change
    change_column :questions, :label, :string, null: false
  end
end
