class AddMoreAttributesToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :nome, :string
    add_column :users, :curso, :string
    add_column :users, :matricula, :string
    add_column :users, :usuario, :string
    add_column :users, :formacao, :string
    add_column :users, :ocupacao, :string
    add_column :users, :departamento, :string
  end
end
