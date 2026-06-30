class CreateTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :templates do |t|
      t.string :nome, null: false
      t.text :descricao
      t.string :publico_alvo

      t.timestamps
    end

    add_index :templates, :nome
  end
end
