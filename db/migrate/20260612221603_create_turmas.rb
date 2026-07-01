class CreateTurmas < ActiveRecord::Migration[8.1]
  def change
    create_table :turmas do |t|
      t.references :materia, null: false, foreign_key: true
      t.integer :numero, null: false
      t.integer :ano, null: false
      t.integer :semestre, null: false

      t.timestamps
    end

    add_index :turmas,
      [ :materia_id, :ano, :semestre, :numero ],
      unique: true
  end
end
