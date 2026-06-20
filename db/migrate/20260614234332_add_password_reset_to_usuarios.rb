class AddPasswordResetToUsuarios < ActiveRecord::Migration[8.1]
  def up
    add_column :usuarios, :password_reset_token, :string unless column_exists?(:usuarios, :password_reset_token)
    add_column :usuarios, :password_reset_sent_at, :datetime unless column_exists?(:usuarios, :password_reset_sent_at)
  end

  def down
    remove_column :usuarios, :password_reset_token if column_exists?(:usuarios, :password_reset_token)
    remove_column :usuarios, :password_reset_sent_at if column_exists?(:usuarios, :password_reset_sent_at)
  end
end
