class RemoveDepartamentoFromMateria < ActiveRecord::Migration[7.1]
  def change
    remove_column :materia, :departamento, :integer
  end
end
