class CreateDocentesFormularios < ActiveRecord::Migration[7.1]
  def change
    create_table :docentes_formularios, id: false do |t|
      t.references :docente, null: false, foreign_key: true
      t.string :formulario_nome, null: false

      t.index [:docente_id, :formulario_nome], unique: true
    end

    add_foreign_key :docentes_formularios, :formularios, column: :formulario_nome, primary_key: :nome
  end
end
