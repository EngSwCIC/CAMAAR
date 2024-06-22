class RemoveFormularioIdFromReportsAlunos < ActiveRecord::Migration[7.1]
  def change
    remove_column :reports_alunos, :formulario_id, :integer
  end
end
