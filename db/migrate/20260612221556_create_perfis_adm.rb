class CreatePerfisAdm < ActiveRecord::Migration[8.1]
  def change
    create_table :perfis_adm, id: false do |t|
      t.primary_key :id
      t.references :departamento, null: false, foreign_key: true

      t.timestamps
    end

    add_foreign_key :perfis_adm, :usuarios, column: :id
  end
end
