class CreatePessoas < ActiveRecord::Migration[8.0]
  def change
    create_table :pessoas do |t|
      t.string :email
      t.string :nome
      t.string :matricula

      t.timestamps
    end
  end
end
