class CreatePerguntas < ActiveRecord::Migration[8.0]
  def change
    create_table :perguntas do |t|
      t.references :ligacao_pergunta, null: false, foreign_key: true
      t.integer :tipo, null: false
      t.string :pergunta, null: false

      t.timestamps
    end
  end
end
