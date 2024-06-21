class CreateTemplates < ActiveRecord::Migration[6.1]
  def change
    create_table :templates do |t|
      t.string :nome, null: false
      t.integer :numeroDeAlternativas, null: false
      t.boolean :discursiva, null: false, default: false
      t.boolean :fatorDeCorrecao, null: false, default: false

      t.timestamps
    end
  end
end
