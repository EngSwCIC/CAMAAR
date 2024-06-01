class AddTemplateToForms < ActiveRecord::Migration[7.1]
  def change
    add_reference :forms, :template, null: false, foreign_key: true
  end
end
