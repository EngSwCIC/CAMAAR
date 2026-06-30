class CreatePasswordResetUsages < ActiveRecord::Migration[8.1]
  def change
    create_table :password_reset_usages do |t|
      t.string :token, null: false

      t.timestamps
    end
    add_index :password_reset_usages, :token, unique: true
  end
end
