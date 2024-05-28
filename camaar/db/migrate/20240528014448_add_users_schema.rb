class AddUsersSchema < ActiveRecord::Migration[7.1]
  def change
    # add_column :users, :id, :integer
    add_column :users, :name, :string, :limit => 50
    add_column :users, :course, :string, :limit => 50
    add_column :users, :registration, :integer
    add_column :users, :user, :integer
    add_column :users, :formation, :string, :limit => 50
    add_column :users, :occupation, :string, :limit => 50
  end
end
