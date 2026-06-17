class Update < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :discentes, :pessoas
    remove_foreign_key :docentes, :pessoas
    add_foreign_key :discentes, :pessoas, column: :pessoa_id, primary_key: :usuario
    add_foreign_key :docentes, :pessoas, column: :pessoa_id, primary_key: :usuario
    rename_column :pessoas, :ehAdm, :admin
    change_column_default :pessoas, :admin, false
    add_column :pessoas, :password, :string
    add_column :pessoas, :reset_password_token, :string
    add_column :pessoas, :reset_password_sent_at, :datetime
  end
end
