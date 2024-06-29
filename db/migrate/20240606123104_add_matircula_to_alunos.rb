class AddMatirculaToAlunos < ActiveRecord::Migration[7.1]
  def change
    add_column :alunos, :matricula, :integer
  end
end
