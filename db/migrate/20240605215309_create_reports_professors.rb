class CreateReportsProfessors < ActiveRecord::Migration[7.1]
  def change
    create_table :reports_professors do |t|
      t.integer :formulario_id

      t.timestamps
    end
  end
end
