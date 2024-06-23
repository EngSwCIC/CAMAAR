class AddRegistrationNumberToSignUpAvailables < ActiveRecord::Migration[6.0]
  def change
    add_column :sign_up_availables, :registration_number, :string
  end
end
