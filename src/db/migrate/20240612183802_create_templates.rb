class CreateTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :templates do |t|
      t.string :codigo
      t.string :nome
      t.string :semestre
      t.belongs_to :user

      t.timestamps
    end
  end
end
