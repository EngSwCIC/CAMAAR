# frozen_string_literal: true

# Migration to add encrypted_password to users table
class AddEncryptedPasswordToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :encrypted_password, :string, null: false, default: ''
  end
end
