class AddRoleRefToSurveys < ActiveRecord::Migration[7.0]
  def change
    add_reference :surveys, :role, foreign_key: true, type: :bigint
  end
end
