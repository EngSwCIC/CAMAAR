class CreateUser < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :nome, null: false
      t.string :usuario, null: false
      t.string :formacao, null: false

      t.timestamps
    end
  end
end
