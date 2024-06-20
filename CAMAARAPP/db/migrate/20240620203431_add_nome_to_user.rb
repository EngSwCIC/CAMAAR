class AddNomeToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :nome, :string
  end
end
