class AddAlunoToMateria < ActiveRecord::Migration[7.1]
  def change
    add_reference :materia, :alunos, null: false, foreign_key: true
  end
end
