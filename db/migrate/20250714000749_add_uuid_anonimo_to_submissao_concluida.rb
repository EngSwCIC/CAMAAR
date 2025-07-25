class AddUuidAnonimoToSubmissaoConcluida < ActiveRecord::Migration[8.0]
  def change
    add_column :submissoes_concluidas, :uuid_anonimo, :string, null: false
    change_column_null :submissoes_concluidas, :user_id, true
  end
end
