class CreateQuestaos < ActiveRecord::Migration[7.1]
  def change
    create_table :questoes do |t|
      t.references :formulario, null: false, foreign_key: true
      t.text :enunciado
      t.integer :tipo_resposta
      t.text :opcoes

      t.timestamps
    end
  end
end
