class CreateAdmins < ActiveRecord::Migration[8.1]
  def change
    create_table :admins do |t|
      t.string :username
      t.string :name
      t.string :email
      t.string :password_digest
      t.references :departamento, null: false, foreign_key: true

      t.timestamps
    end
  end
end
