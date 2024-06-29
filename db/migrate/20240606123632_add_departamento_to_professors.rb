class AddDepartamentoToProfessors < ActiveRecord::Migration[7.1]
  def change
    add_reference :professors, :departamento, null: false, foreign_key: true
  end
end
