class RemoveAlunoIdFromMateria < ActiveRecord::Migration[7.1]
  def change
    remove_column :materia, :aluno_id, :integer
  end
end
