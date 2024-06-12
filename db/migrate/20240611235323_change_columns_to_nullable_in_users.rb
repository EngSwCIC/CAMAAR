class ChangeColumnsToNullableInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_null :users, :reset_password_token, true
    change_column_null :users, :reset_password_sent_at, true
    change_column_null :users, :session_key, true
  end
end