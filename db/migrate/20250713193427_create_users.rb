# db/migrate/[timestamp]_create_users.rb
class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :password_reset_token
      t.datetime :password_reset_sent_at
      t.string :remember_digest

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :password_reset_token, unique: true
    add_index :users, :remember_digest, unique: true
  end
end