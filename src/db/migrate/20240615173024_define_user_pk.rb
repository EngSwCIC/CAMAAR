class DefineUserPk < ActiveRecord::Migration[7.1]
  def change
    add_index :users, :usuario, unique: true
  end
end
