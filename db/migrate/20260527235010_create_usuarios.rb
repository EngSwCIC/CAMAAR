class CreateUsuarios < ActiveRecord::Migration[8.1]
  def change
    create_table :usuarios do |t|
      t.string :matricula
      t.string :senha_hash
      t.string :email
      t.string :nome
      t.string :formacao
      t.string :type
      t.references :curso, null: false, foreign_key: true
      t.references :departamento, null: false, foreign_key: true

      t.timestamps
    end
    add_index :usuarios, :matricula, unique: true
  end
end
