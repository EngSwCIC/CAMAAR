class AddHorarioToMateria < ActiveRecord::Migration[7.1]
  def change
    add_column :materia, :horario, :datetime
  end
end
