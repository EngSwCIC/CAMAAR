class CreateTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :templates do |t|
      t.string :nome, null: false
      t.integer :numeroDeAlternativas, null: false
      t.boolean :discursiva, null: false
      t.boolean :fatorDeCorrecao, null: false
      t.references :administrador, null: false, foreign_key: true

      t.timestamps
    end
  end
end
