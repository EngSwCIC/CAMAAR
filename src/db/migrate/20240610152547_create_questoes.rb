class CreateQuestoes < ActiveRecord::Migration[7.1]
  def change
    create_table :questoes do |t|
      t.string :codigo
      t.string :questao
      t.text :resposta
      t.integer :numero

      t.timestamps
    end
  end
end
