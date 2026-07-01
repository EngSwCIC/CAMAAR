class AddNomeAndFieldsToTurmas < ActiveRecord::Migration[8.1]
  def change
    add_column :turmas, :nome, :string
  end
end
