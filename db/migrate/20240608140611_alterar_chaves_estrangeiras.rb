class AlterarChavesEstrangeiras < ActiveRecord::Migration[7.1]
  def change
    rename_column :alunos, :materia_id, :materium_id
    rename_column :professors, :materia_id, :materium_id
   
  end
end

