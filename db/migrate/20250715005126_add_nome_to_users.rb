class AddNomeToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :nome, :string
  end
end
