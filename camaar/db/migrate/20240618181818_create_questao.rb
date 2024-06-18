class CreateQuestao < ActiveRecord::Migration[7.1]
  def change
    create_table :questaos do |t|
      t.string :pergunta, null: false
      t.decimal :pontos, null: false, precision: 10, scale: 2
      t.decimal :fatorDeCorrecao, null: false, default: 0, precision: 10, scale: 2
      t.string :alternativaCorreta, null: false

      t.references :tipo, null: false, foreign_key: true
      t.references :template, null: false, foreign_key: true

      t.timestamps
    end
  end
end
