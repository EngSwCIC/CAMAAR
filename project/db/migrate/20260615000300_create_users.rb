class CreateUsers < ActiveRecord::Migration[8.1]
  def change # rubocop:disable Metrics/AbcSize
    create_table :users do |t|
      t.references :department, foreign_key: true
      t.string :name, null: false
      t.string :email, null: false
      t.string :registration, null: false
      t.integer :role, null: false, default: 1
      t.string :password_digest
      t.string :password_setup_token_digest
      t.datetime :password_setup_sent_at
      t.string :password_reset_token_digest
      t.datetime :password_reset_sent_at

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :registration, unique: true
    add_index :users, :password_setup_token_digest, unique: true
    add_index :users, :password_reset_token_digest, unique: true
  end
end
