class RemoveTypeFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :type, :string
  end
end
