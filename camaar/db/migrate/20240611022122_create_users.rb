class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :nome, null: false
      t.string :email, null: false
      t.string :password, null:false
      t.string :type, null: false, default: 'Dicente'
      t.string :usuario, null: false
      t.string :formacao, null: false

      t.timestamps
    end
  end
end
