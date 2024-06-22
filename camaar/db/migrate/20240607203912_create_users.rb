class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :nome
      t.string :email
      t.string :curso
      t.string :matricula
      t.string :formacao
      t.string :ocupacao

      t.timestamps
    end
  end
end
