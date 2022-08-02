class AddMemberRefToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :member, foreign_key: true, type: :bigint
  end
end
