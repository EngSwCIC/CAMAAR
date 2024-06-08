class NomeAlteradoChave < ActiveRecord::Migration[7.1]
  def change
    rename_table :materia, :materium
  end
end
