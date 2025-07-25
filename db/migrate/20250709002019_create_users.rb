# frozen_string_literal: true

# Migration to create users table
class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :name
      t.string :matricula
      t.integer :role, default: 0, null: false

      t.timestamps
    end
  end
end
