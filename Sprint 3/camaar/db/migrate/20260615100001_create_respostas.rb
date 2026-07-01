class CreateRespostas < ActiveRecord::Migration[7.1]
  def change
    create_table :respostas do |t|
      t.references :user,      null: false, foreign_key: true
      t.references :avaliacao, null: false, foreign_key: { to_table: :avaliacaos }
      t.references :questao,   null: false, foreign_key: { to_table: :questaos }
      t.string :texto

      t.timestamps
    end

    add_index :respostas, [:user_id, :avaliacao_id, :questao_id], unique: true
  end
end
