class CreateQuestoes < ActiveRecord::Migration[6.1]
  def change
    create_table :questoes do |t|
      t.string :pergunta, null: false
      t.jsonb :alternativas, null: false, default: {}
      t.decimal :pontos, null: false, default: 0
      t.decimal :fatorDeCorrecao, null: false, default: 0
      t.integer :alternativaCorreta, default: false

      t.timestamps
    end
  end
end
