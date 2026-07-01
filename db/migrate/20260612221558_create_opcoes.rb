class CreateOpcoes < ActiveRecord::Migration[8.1]
  def change
    create_table :opcoes do |t|
      t.references :questao, null: false, foreign_key: true
      t.integer :numero, null: false
      t.text :texto, null: false

      t.timestamps
    end

    add_index :opcoes, [ :questao_id, :numero ], unique: true
  end
end
