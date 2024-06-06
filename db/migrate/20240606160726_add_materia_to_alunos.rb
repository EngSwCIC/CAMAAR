class AddMateriaToAlunos < ActiveRecord::Migration[7.1]
  def change
    add_reference :alunos, :materia, null: false, foreign_key: true
  end
end
