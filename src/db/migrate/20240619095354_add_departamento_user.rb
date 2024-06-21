class AddDepartamentoUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :departamento, :string, default: '', null: false
  end
end
