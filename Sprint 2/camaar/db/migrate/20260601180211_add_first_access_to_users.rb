class AddFirstAccessToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :first_access, :boolean, default: true, null: false
  end
end
