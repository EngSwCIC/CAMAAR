class CreateMateria < ActiveRecord::Migration[8.1]
  def change
    create_table :materia, if_not_exists: true do |t|
      t.string :codigoMateria
      t.string :nome_materia
      t.string :descricao_materia
      t.references :departamento, null: false, foreign_key: true

      t.timestamps
    end
  end
end
