class CreateFormularios < ActiveRecord::Migration[7.1]
  def change
    create_table :formularios do |t|
      t.string :nome, null: false
      t.string :turmas, array: true, default: []
      t.date :dataDeTermino, null:false
      t.jsonb :resultados, default: {}

      t.references :docente, null: false, foreign_key: true
      t.references :questao, foreign_key: true

      t.timestamps
    end
  end
end
