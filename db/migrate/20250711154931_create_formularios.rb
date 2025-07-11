class CreateFormularios < ActiveRecord::Migration[8.0]
  def change
    create_table :formularios do |t|
      t.references :template, null: false, foreign_key: true
      t.references :turma, null: false, foreign_key: true
      t.references :coordenador, null: false, foreign_key: true
      t.datetime :data_envio
      t.datetime :data_fim

      t.timestamps
    end
  end
end
