class AddDocenteToTurmas < ActiveRecord::Migration[7.1]
  def change
    add_reference :turmas, :docente, null: false, foreign_key: true
  end
end
