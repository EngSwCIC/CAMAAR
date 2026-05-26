class CreateTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :templates do |t|
      t.string  :titulo,     limit: 150, null: false
      t.text    :descricao
      t.bigint  :criador_id,             null: false
      t.integer :versao,                 null: false, default: 1
      t.boolean :ativo,                  null: false, default: true

      t.timestamps
    end

    add_index :templates, :criador_id

    add_foreign_key :templates, :usuarios, column: :criador_id
  end
end
