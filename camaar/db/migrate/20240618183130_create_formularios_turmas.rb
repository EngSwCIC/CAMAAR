class CreateFormulariosTurmas < ActiveRecord::Migration[7.1]
  def change
    create_table :formularios_turmas do |t|
      t.references :formulario, null: false, foreign_key: true
      t.references :turma, null: false, foreign_key: true

      t.timestamps
    end
  end
end
