class CreateTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :templates do |t|
      t.references :adm, null: false, foreign_key: { to_table: :perfis_adm }
      t.string :titulo, null: false
      t.text :descricao
      t.datetime :criado_em, null: false

      t.timestamps
    end

    add_index :templates, [ :adm_id, :titulo ], unique: true
  end
end
