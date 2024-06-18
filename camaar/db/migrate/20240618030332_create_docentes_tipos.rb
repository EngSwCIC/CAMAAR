class CreateDocentesTipos < ActiveRecord::Migration[7.1]
  def change
    create_table :docentes_tipos, id: false do |t|
      t.references :docente, null: false, foreign_key: true
      t.string :tipo_nome, null: false

      t.index [:docente_id, :tipo_nome], unique: true
    end

    add_foreign_key :docentes_tipos, :tipos, column: :tipo_nome, primary_key: :nome
  end
end
