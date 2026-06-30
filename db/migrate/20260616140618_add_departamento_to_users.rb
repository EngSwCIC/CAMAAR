class AddDepartamentoToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :departamento, :string
  end
end
