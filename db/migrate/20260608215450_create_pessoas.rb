class CreatePessoas < ActiveRecord::Migration[7.1]
  def change
    create_table :pessoas, id:false do |t|
      t.string :usuario, primary_key:true
      t.string :nome
      t.string :email
      t.string :formacao
      t.string :ocupacao

      t.timestamps
    end
  end
end
