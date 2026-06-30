class CreateFormularios < ActiveRecord::Migration[8.1]
  def change
    create_table :formularios do |t|
      t.references :template, null: false, foreign_key: true
      t.references :turma, null: false, foreign_key: true
      t.string :titulo, null: false
      t.datetime :prazo

      t.timestamps
    end
  end
end
