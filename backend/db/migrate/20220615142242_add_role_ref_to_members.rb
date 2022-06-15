class AddRoleRefToMembers < ActiveRecord::Migration[7.0]
  def change
    add_reference :members, :role, foreign_key: true
  end
end
