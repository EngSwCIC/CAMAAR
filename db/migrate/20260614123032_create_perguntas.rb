class CreatePerguntas < ActiveRecord::Migration[8.1]
  def change
    create_table :perguntas do |t|
      t.references :formulario, null: false, foreign_key: true
      t.text :enunciado
      t.string :tipo_pergunta
      t.boolean :obrigatoria

      t.timestamps
    end
  end
end
