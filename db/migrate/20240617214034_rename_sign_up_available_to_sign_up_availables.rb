class RenameSignUpAvailableToSignUpAvailables < ActiveRecord::Migration[7.1]
  def change
    rename_table :signUpAvailable, :sign_up_availables

    add_index :sign_up_availables, :email, unique: true
  end
end