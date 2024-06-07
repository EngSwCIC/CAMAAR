class AddCursoToAlunos < ActiveRecord::Migration[7.1]
  def change
    add_column :alunos, :curso, :string
  end
end
