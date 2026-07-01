class AddRedefinicaoSenhaToUsuarios < ActiveRecord::Migration[8.1]
  def change
    add_column :usuarios, :redefinicao_senha_token, :string
    add_column :usuarios, :redefinicao_senha_sent_at, :datetime

    add_index :usuarios, :redefinicao_senha_token, unique: true
  end
end
