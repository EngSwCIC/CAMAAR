class CreatePendingRegistrations < ActiveRecord::Migration[8.1]
  def change
    create_table :pending_registrations do |t|
      t.string :email, null: false
      t.string :token, null: false
      t.string :nome
      t.string :matricula
      t.string :perfil, default: "discente"

      t.timestamps
    end
    add_index :pending_registrations, :email
    add_index :pending_registrations, :token, unique: true
  end
end
