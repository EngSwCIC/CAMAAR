class AddNomeToTurmas < ActiveRecord::Migration[7.1]
  def change
    add_column :turmas, :nome, :string
  end
end
