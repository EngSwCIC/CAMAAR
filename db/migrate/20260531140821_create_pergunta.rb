class CreatePergunta < ActiveRecord::Migration[8.1]
  def change
    create_table :pergunta do |t|
      t.integer :tipo_pergunta
      t.string :gabarito_discursiva
      t.string :gabarito_radio
      t.text :opcoes_radio
      t.references :template_formulario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
