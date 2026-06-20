class AddAuthToUsuarios < ActiveRecord::Migration[8.1]
  def up
    add_column :usuarios, :password_digest, :string unless column_exists?(:usuarios, :password_digest)
  end

  def down
    remove_column :usuarios, :password_digest if column_exists?(:usuarios, :password_digest)
  end
end
