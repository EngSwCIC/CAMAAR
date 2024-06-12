class CreateDocentes < ActiveRecord::Migration[7.1]
  def change
    create_table :docentes do |t|
      t.string :departamento, null:false
      t.string :formularios, array: true, default: []
      t.string :templates, array: true, default: []
      t.string :turmas, array: true, default: []
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
