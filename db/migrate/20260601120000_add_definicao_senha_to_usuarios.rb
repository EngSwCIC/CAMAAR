class AddDefinicaoSenhaToUsuarios < ActiveRecord::Migration[8.1]
  def change
    add_column :usuarios, :definicao_senha_token, :string
    add_column :usuarios, :definicao_senha_sent_at, :datetime

    add_index :usuarios, :definicao_senha_token, unique: true
  end
end
