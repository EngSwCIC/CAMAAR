class AddProfessorToMateria < ActiveRecord::Migration[7.1]
  def change
    add_reference :materia, :professors, null: false, foreign_key: true
  end
end
