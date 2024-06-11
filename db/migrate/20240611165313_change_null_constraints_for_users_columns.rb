class ChangeNullConstraintsForUsersColumns < ActiveRecord::Migration[7.1]
  def change
    change_column_null :users, :email, false
    change_column_null :users, :reset_password_token, false
    change_column_null :users, :reset_password_sent_at, false
    change_column_null :users, :created_at, false
    change_column_null :users, :salt, false
    change_column_null :users, :username, false
    change_column_null :users, :password, false
  end
end