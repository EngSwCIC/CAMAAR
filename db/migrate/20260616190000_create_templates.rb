class CreateTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :templates do |t|
      t.string :nome, null: false
      t.text :descricao

      t.references :user, null: false, foreign_key: true

      # Template do qual este é uma nova versão
      t.references :parent_template,
                   foreign_key: { to_table: :templates }

      # Número da versão
      t.integer :version, default: 1, null: false

      t.timestamps
    end
  end
end