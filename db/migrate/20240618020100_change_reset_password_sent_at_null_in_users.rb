class ChangeResetPasswordSentAtNullInUsers < ActiveRecord::Migration[6.1]
  def up
    change_column :users, :reset_password_sent_at, :datetime, null: true
  end

  def down
    change_column :users, :reset_password_sent_at, :datetime, null: false
  end
end