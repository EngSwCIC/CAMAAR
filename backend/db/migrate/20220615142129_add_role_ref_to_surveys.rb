class AddRoleRefToSurveys < ActiveRecord::Migration[7.0]
  def change
    add_reference :surveys, :role, foreign_key: true
  end
end
