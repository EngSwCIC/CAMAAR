class AddDepartamentoToMateria < ActiveRecord::Migration[7.1]
  def change
    add_reference :materia, :departamento, null: false, foreign_key: true
  end
end
