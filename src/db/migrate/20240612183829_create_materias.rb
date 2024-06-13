class CreateMaterias < ActiveRecord::Migration[7.1]
  def change
    create_table :materias do |t|
      t.string :code
      t.string :nome

      t.timestamps
    end
  end
end
