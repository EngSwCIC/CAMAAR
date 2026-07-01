class AddPrimeiroAcessoToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :primeiro_acesso, :boolean, null: false, default: true
    User.where.not(password_digest: nil).update_all(primeiro_acesso: false)
  end
end
