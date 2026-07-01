# frozen_string_literal: true

class CreateUsuarios < ActiveRecord::Migration[8.1]
  def change
    create_table :usuarios do |t|
      t.string :nome, null: false
      t.string :email, null: false
      t.string :matricula, null: false
      t.integer :status, null: false, default: 0
      t.string :senha_digest

      t.timestamps
    end

    add_index :usuarios, :email, unique: true
    add_index :usuarios, :matricula, unique: true
  end
end
