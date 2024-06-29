class AddMateriaToProfessors < ActiveRecord::Migration[7.1]
  def change
    add_reference :professors, :materia, null: false, foreign_key: true
  end
end
