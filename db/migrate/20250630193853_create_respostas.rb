class CreateRespostas < ActiveRecord::Migration[8.0]
  def change
    create_table :respostas do |t|
      t.references :formulario, null: false, foreign_key: true
      t.references :pergunta, null: false, foreign_key: true
      t.string :conteudo, null: false

      t.timestamps
    end
  end
end
