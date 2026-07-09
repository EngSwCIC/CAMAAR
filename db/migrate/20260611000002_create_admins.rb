class CreateAdmins < ActiveRecord::Migration[8.1]
  def change
    create_table :admins do |t|
      t.references :user, null: false, foreign_key: true
      t.references :departamento, null: false, foreign_key: true

      t.timestamps
    end
    add_index :admins, [ :user_id, :departamento_id ], unique: true
  end
end
