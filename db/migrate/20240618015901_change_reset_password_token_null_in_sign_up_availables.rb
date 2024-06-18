class ChangeResetPasswordTokenNullInSignUpAvailables < ActiveRecord::Migration[7.1]
  def change
    change_column_null :users, :reset_password_token, true
  end
end
