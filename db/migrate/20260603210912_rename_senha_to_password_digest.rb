class RenameSenhaToPasswordDigest < ActiveRecord::Migration[8.1]
  def up
    remove_column :usuarios, :senha, :string if column_exists?(:usuarios, :senha)
  end

  def down
    add_column :usuarios, :senha, :string unless column_exists?(:usuarios, :senha)
  end
end
