class CreateTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :templates do |t|
      t.string :nome
      t.string :semestre
      t.integer :usuario

      t.timestamps
    end
  end
end
