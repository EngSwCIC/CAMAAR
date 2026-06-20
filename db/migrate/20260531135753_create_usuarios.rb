class CreateUsuarios < ActiveRecord::Migration[8.1]
  def change
    create_table :usuarios do |t|
      t.string :email
      t.string :matricula
      t.string :senha
      t.string :nome
      t.integer :role

      t.timestamps
    end
  end
end
