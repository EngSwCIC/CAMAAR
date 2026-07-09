class CreateTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :templates do |t|
      t.string :nome, null: false
      t.string :semestre, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
