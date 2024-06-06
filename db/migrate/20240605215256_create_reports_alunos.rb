class CreateReportsAlunos < ActiveRecord::Migration[7.1]
  def change
    create_table :reports_alunos do |t|
      t.integer :formulario_id

      t.timestamps
    end
  end
end
