class AddCoordinatorToTemplates < ActiveRecord::Migration[7.1]
  def change
    add_reference :templates, :coordinator, null: false, foreign_key: true
  end
end
