class CreateOpcoes < ActiveRecord::Migration[8.0]
  def change
    create_table :opcoes do |t|
      t.references :pergunta, null: false, foreign_key: true
      t.integer :item, null: false
      t.text :opcao, null: false
      t.timestamps
    end

    add_index :opcoes, [:pergunta_id, :item], unique: true
  end
end


