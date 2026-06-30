class AddDepartamentoToTurmas < ActiveRecord::Migration[8.1]
  def change
    add_column :turmas, :departamento, :string
  end
end
