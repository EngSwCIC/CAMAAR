class CreateFormularios < ActiveRecord::Migration[8.1]
  def change
    create_table :formularios do |t|
      t.references :turma, null: false, foreign_key: true

      t.timestamps
    end
  end
end
