class ChangeAdminIdFkToUsers < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :templates, :admins
    remove_foreign_key :formularios, :admins

    add_foreign_key :templates, :users, column: :admin_id
    add_foreign_key :formularios, :users, column: :admin_id
  end
end
