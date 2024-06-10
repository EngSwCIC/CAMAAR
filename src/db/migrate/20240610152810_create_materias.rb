class CreateMaterias < ActiveRecord::Migration[7.1]
  def change
    create_table :materias do |t|

      t.timestamps
    end
  end
end
