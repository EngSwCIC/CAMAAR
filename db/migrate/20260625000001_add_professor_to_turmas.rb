class AddProfessorToTurmas < ActiveRecord::Migration[8.1]
  def change
    add_column :turmas, :professor, :string
  end
end
