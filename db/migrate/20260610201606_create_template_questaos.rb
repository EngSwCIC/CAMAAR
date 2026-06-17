class CreateTemplateQuestaos < ActiveRecord::Migration[7.1]
  def change
    create_table :template_questoes do |t|
      t.references :template, null: false, foreign_key: true
      t.text :enunciado
      t.integer :tipo_resposta
      t.text :opcoes

      t.timestamps
    end
  end
end
