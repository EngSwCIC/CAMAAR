class CreateOpcoesPergunta < ActiveRecord::Migration[8.0]
  def change
    create_table :opcoes_pergunta do |t|
      t.references :pergunta, null: false, foreign_key: true
      t.string :texto

      t.timestamps
    end
  end
end
