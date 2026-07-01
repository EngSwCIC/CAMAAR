class CreateFormularios < ActiveRecord::Migration[8.1]
  def change
    create_table :formularios do |t|
      t.string :title
      t.string :target_role
      t.string :status
      t.references :template, null: false, foreign_key: true
      t.references :turma, null: false, foreign_key: true
      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
