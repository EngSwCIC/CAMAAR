class AddFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :curso, :string
    add_column :users, :departamento, :string
    add_column :users, :formacao, :string
  end
end
