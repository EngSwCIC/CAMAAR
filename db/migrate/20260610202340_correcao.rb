class Correcao < ActiveRecord::Migration[7.1]
  def chang
    rename_column :pessoas, :password, :password_digest
    rename_table :questaos, :questoes
    rename_table :template_questaos, :template_questoes
    rename_table :resposta, :respostas
    add_foreign_key :templates, :pessoas, column: :pessoa_id, primary_key: :usuario
  end
end
