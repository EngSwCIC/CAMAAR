class AddTemplateIdToQuestion < ActiveRecord::Migration[7.1]
  def change
    add_reference :questions, :template, foreign_key: true
  end
end
