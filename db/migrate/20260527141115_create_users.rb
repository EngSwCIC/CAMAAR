class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :matricula
      t.string :password_digest
      t.string :role

      t.timestamps
    end
  end
end
