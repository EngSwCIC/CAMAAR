class AddNomeToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :nome, :string
    add_column :users, :departamento, :string
  end
end
