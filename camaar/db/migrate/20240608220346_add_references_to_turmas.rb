class AddReferencesToTurmas < ActiveRecord::Migration[7.1]
  def change
    add_reference :turmas, :materia, null: false, foreign_key: true
  end
end
