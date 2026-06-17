class CreateRespostaElems < ActiveRecord::Migration[8.1]
  def change
    create_table :resposta_elems do |t|
      t.text :texto_resposta
      t.references :resposta_form, null: false, foreign_key: true
      t.references :elemento_form, null: false, foreign_key: true
      t.references :campo_form, null: false, foreign_key: true

      t.timestamps
    end
  end
end
