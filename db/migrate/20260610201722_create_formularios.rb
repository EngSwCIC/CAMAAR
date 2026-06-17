class CreateFormularios < ActiveRecord::Migration[7.1]
  def change
    create_table :formularios do |t|
      t.references :turma, null: false, foreign_key: true
      t.references :template, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
