class AddUsernameAndPasswordToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :username, :string
    add_column :users, :password, :string
    remove_column :users, :encrypted_password, :string
  end
end
