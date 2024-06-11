class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :nome, null: false
      t.string :senha, null:false

      t.timestamps
    end
  end
end
