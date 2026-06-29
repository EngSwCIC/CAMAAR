class AllowNullPasswordDigest < ActiveRecord::Migration[8.1]
  def change
    change_column_null :users, :password_digest, true
  end
end
