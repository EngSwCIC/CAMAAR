class RenameMaterium < ActiveRecord::Migration[7.1]
  def change
    rename_table :materium, :materia
    rename_column :alunos, :materium_id, :materia_id
    rename_column :professors, :materium_id, :materia_id
  end
end
