class Correcao2 < ActiveRecord::Migration[7.1]
  def change
    rename_column :pessoas, :password, :password_digest
    add_foreign_key :templates, :pessoas, column: :pessoa_id, primary_key: :usuario
  end
end