class AddNomeToAlunos < ActiveRecord::Migration[7.1]
  def change
    add_column :alunos, :nome, :string
  end
end
