class CreateRespostaItens < ActiveRecord::Migration[8.1]
  def change
    create_table :resposta_itens do |t|
      t.bigint  :resposta_id,          null: false
      t.bigint  :questao_template_id,  null: false
      t.text    :valor_texto
      t.decimal :valor_numerico,       precision: 10, scale: 2
      t.string  :valor_opcao,          limit: 100

      t.timestamps
    end

    add_index :resposta_itens, [ :resposta_id, :questao_template_id ], unique: true
    add_index :resposta_itens, :questao_template_id

    add_foreign_key :resposta_itens, :respostas,         column: :resposta_id
    add_foreign_key :resposta_itens, :questoes_template, column: :questao_template_id
  end
end
