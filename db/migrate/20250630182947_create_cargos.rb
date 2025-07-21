class CreateCargos < ActiveRecord::Migration[8.0]
  def change
    create_table :cargos do |t|
      t.string :email, null: false
      t.integer :funcao, null: false
      t.timestamps
    end

    add_foreign_key :cargos, :pessoas, column: :email, primary_key: :email
    add_index :cargos, [:email, :funcao], unique: true
  end
end
