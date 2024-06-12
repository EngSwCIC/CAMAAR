class CreateTurmas < ActiveRecord::Migration[7.1]
  def change
    create_table :turmas do |t|

      t.string :codigo, null: false
      t.string :nome_materia, null: false
      t.string :semestre, null: false
      t.string :horario, null: false

      t.string :dicentes, array: true, default: []
      t.string :formularios, array: true, default: []
      t.references :docente, null: false, foreign_key: true

      t.timestamps
    end
  end
end
