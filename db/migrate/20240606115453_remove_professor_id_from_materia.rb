class RemoveProfessorIdFromMateria < ActiveRecord::Migration[7.1]
  def change
    remove_column :materia, :professor_id, :integer
  end
end
