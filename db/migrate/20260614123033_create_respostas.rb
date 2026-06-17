class CreateRespostas < ActiveRecord::Migration[8.1]
  def change
    create_table :respostas do |t|
      t.references :formulario, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :pergunta, null: false, foreign_key: true
      t.text :conteudo

      t.timestamps
    end
  end
end
