class CreateRespostas < ActiveRecord::Migration[8.1]
  def change
    create_table :respostas do |t|
      t.references :questao, null: false, foreign_key: true
      t.references :avaliacao, null: false, foreign_key: true

      t.timestamps
    end

    add_index :respostas, [ :questao_id, :avaliacao_id ], unique: true
  end
end
