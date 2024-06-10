class AddCollumnsToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :nome, :string, default: '', null: false
    add_column :users, :curso, :string, default: '', null: false
    add_column :users, :ocupacao, :string, default: '', null: false
    add_column :users, :formacao, :string, default: '', null: false
    add_column :users, :matricula, :string, default: '', null: false
    add_column :users, :usuario, :string, default: '', null: false
  end
end
