class RemoveFormsMateriaFromMateria < ActiveRecord::Migration[7.1]
  def change
    remove_column :materia, :forms_materia, :integer
  end
end
