class CreateTipo < ActiveRecord::Migration[7.1]
  def change
    create_table :tipos do |t|
      t.string :nome, null: false
      t.integer :numeroDeAlternativas, null: false
      t.boolean :discursiva?, null: false
      t.timestamps
    end
  end
end
