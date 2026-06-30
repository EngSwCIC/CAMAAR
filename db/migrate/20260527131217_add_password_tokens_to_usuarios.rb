class AddPasswordTokensToUsuarios < ActiveRecord::Migration[8.1]
  def change
    add_column :usuarios, :setup_token, :string
    add_column :usuarios, :setup_token_sent_at, :datetime
    add_column :usuarios, :setup_token_used, :boolean, default: false, null: false
    add_column :usuarios, :reset_token, :string
    add_column :usuarios, :reset_token_sent_at, :datetime
    add_column :usuarios, :reset_token_used, :boolean, default: false, null: false
  end
end
