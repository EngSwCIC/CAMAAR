class AddPasswordToUsuarios < ActiveRecord::Migration[7.1]
  def change
    add_column :usuarios, :senha, :string
  end
end
