class CreateMaterias < ActiveRecord::Migration[8.0]
  def change
    create_table :materias, id: false do |t|
      t.string :id, primary_key: true
      t.string :nome

      t.timestamps
    end
  end
end
