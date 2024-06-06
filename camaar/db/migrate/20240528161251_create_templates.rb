class CreateTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :templates do |t|
      t.string :name
      t.boolean :draft
      t.json :questions

      t.timestamps
    end
  end
end
