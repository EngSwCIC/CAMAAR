class CreateUsuarios < ActiveRecord::Migration[8.1]
  def change
    create_table :usuarios do |t|
      t.string  :nome,        limit: 150, null: false
      t.string  :email,       limit: 150, null: false
      t.string  :matricula,   limit: 30
      t.string  :perfil,      limit: 20,  null: false
      t.bigint  :departamento_id
      t.bigint  :curso_id
      t.string  :senha_hash,  limit: 255, null: false
      t.boolean :ativo,                   null: false, default: true

      t.timestamps
    end

    add_index :usuarios, :email,      unique: true
    add_index :usuarios, :matricula,  unique: true
    add_index :usuarios, :departamento_id
    add_index :usuarios, :curso_id

    add_foreign_key :usuarios, :departamentos, column: :departamento_id
    add_foreign_key :usuarios, :cursos,        column: :curso_id
  end
end
