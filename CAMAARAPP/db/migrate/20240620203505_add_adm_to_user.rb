class AddAdmToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :adm, :string
  end
end
