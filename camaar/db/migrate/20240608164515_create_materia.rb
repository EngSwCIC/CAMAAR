class CreateMateria < ActiveRecord::Migration[7.1]
  def change
    create_table :materia do |t|
      t.string :codigo
      t.string :nome

      t.timestamps
    end
  end
end
