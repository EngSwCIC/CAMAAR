class AddConstraintsToAlunos < ActiveRecord::Migration[7.1]
  def change
    change_column_null :alunos, :nome, false
    change_column_null :alunos, :curso, false
    change_column_null :alunos, :matricula, false
    add_index :alunos, :matricula, unique: true
  end
end
