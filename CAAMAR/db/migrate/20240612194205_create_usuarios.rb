class CreateUsuarios < ActiveRecord::Migration[7.1]
  def change
    create_table :usuarios do |t|
      t.string :matricula
      t.string :nome
      t.string :email
      t.string :formacao

      t.timestamps

    end
  end
end
