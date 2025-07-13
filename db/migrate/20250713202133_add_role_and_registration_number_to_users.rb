class AddRoleAndRegistrationNumberToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :role, :string, default: 'discente'
    add_column :users, :registration_number, :string

    add_index :users, :registration_number, unique: true
    add_index :users, :role
  end
end