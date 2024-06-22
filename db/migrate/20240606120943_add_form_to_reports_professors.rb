class AddFormToReportsProfessors < ActiveRecord::Migration[7.1]
  def change
    add_reference :reports_professors, :formularios, null: false, foreign_key: true
  end
end
