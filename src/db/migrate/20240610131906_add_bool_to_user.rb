class AddBoolToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :isAdmin, :boolean, default: false
  end
end
