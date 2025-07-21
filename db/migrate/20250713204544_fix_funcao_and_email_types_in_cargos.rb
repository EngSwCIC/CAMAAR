class FixFuncaoAndEmailTypesInCargos < ActiveRecord::Migration[8.0]
  def change
    create_table :cargos_temp, id: false do |t|
      t.string :email, null: false
      t.integer :funcao, null: false
      t.timestamps
    end

    execute <<~SQL
      INSERT INTO cargos_temp (email, funcao, created_at, updated_at)
      SELECT email, CAST(funcao AS INTEGER), created_at, updated_at FROM cargos;
    SQL

    drop_table :cargos

    rename_table :cargos_temp, :cargos

    add_foreign_key :cargos, :pessoas, column: :email, primary_key: :email
    add_index :cargos, [:email, :funcao], unique: true
  end
end
