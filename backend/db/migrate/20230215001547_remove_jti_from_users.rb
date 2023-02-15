class RemoveJtiFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :jti
  end
end
