class AddSemesterToTemplates < ActiveRecord::Migration[8.1]
  def change
    add_column :templates, :semester, :string
    change_column_null :templates, :user_id, true
  end
end
