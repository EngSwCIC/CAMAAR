class CreateQuestaos < ActiveRecord::Migration[7.1]
  def change
    create_table :questaos do |t|
      t.string :pergunta, null: false
      t.jsonb :alternativas, null: false, default: {}
      t.decimal :pontos, null: false, precision: 10, scale: 2
      t.decimal :fatorDeCorrecao, null: false, default: 0, precision: 10, scale: 2
      t.string :alternativaCorreta, null: false

      t.references :formulario, null: false, foreign_key: true
      t.references :template, null: false, foreign_key: true

      t.timestamps
    end
  end
end
