class CreateMateriasProfessorsJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_table :materias_professors, id: false do |t|
      t.references :materia, null: false, foreign_key: true
      t.references :professor, null: false, foreign_key: true
    end

    add_index :materias_professors, [:materia_id, :professor_id], unique: true
    add_index :materias_professors, [:professor_id, :materia_id], unique: true

    remove_reference :materia, :professors, foreign_key: true if column_exists?(:materia, :professors_id)
    remove_reference :professors, :materia, foreign_key: true if column_exists?(:professors, :materia_id)
  end
end
