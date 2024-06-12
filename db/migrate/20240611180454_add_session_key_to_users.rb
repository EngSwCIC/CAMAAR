class AddSessionKeyToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :session_key, :string
  end
end
