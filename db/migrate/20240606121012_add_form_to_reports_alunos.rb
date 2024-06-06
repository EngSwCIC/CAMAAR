class AddFormToReportsAlunos < ActiveRecord::Migration[7.1]
  def change
    add_reference :reports_alunos, :formularios, null: false, foreign_key: true
  end
end
