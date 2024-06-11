class CreateFormularios < ActiveRecord::Migration[7.1]
  def change
    create_table :formularios do |t|
      t.jsonb :turmas, default: []
      t.date :dataDeTermino, null:false
      t.jsonb :resultados, default: {}
      t.references :administrador, null: false, foreign_key: true

      t.timestamps
    end
  end
end
