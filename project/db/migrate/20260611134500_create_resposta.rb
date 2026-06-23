class CreateResposta < ActiveRecord::Migration[8.1]
  def change
    create_table :resposta do |t|
      t.text :valor_texto
      t.integer :valor_numerico
      t.references :submissao, null: false, foreign_key: true
      t.references :questao, null: false, foreign_key: true

      t.timestamps
    end
  end
end
