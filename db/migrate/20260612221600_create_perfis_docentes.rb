class CreatePerfisDocentes < ActiveRecord::Migration[8.1]
  def change
    create_table :perfis_docentes, id: false do |t|
      t.primary_key :id
      t.references :departamento, null: false, foreign_key: true

      t.timestamps
    end

    add_foreign_key :perfis_docentes, :usuarios, column: :id
  end
end
