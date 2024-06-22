class RemoveFormularioIdFromReportsProfessors < ActiveRecord::Migration[7.1]
  def change
    remove_column :reports_professors, :formulario_id, :integer
  end
end
