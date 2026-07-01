class CreateResposta < ActiveRecord::Migration[7.1]
  def change
    create_table :respostas do |t|
      t.references :questao, null: false, foreign_key: true
      t.references :discente, null: false, foreign_key: true
      t.text :conteudo

      t.timestamps
    end
  end
end
