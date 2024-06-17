class AddSignUpAvailable < ActiveRecord::Migration[7.1]
  def change
    create_table :signUpAvailable do |t|
      t.string :email, null: false
      t.string :key, null: false
      t.timestamps
    end
  end
end