class CreateTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :templates do |t|
      t.string :codigo
      t.string :nome
      t.string :semestre
      t.datetime :last_update

      t.timestamps
    end
  end
end
