class AddNomeToProfessors < ActiveRecord::Migration[7.1]
  def change
    add_column :professors, :nome, :string
  end
end
