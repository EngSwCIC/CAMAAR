class CreateTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :templates do |t|
      t.string :name, default: "Draft"
      t.boolean :draft, default: true
      t.timestamps
    end
  end
end
