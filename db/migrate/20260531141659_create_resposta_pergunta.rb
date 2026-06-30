class CreateRespostaPergunta < ActiveRecord::Migration[8.1]
  def change
    create_table :resposta_pergunta do |t|
      t.datetime :dataResposta
      t.references :formulario, null: false, foreign_key: true
      t.references :usuario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
