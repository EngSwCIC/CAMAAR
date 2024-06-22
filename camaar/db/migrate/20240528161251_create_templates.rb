class CreateTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :templates do |t|
      t.string :name, default: "draft"
      t.string :role, default: "discente"
      t.boolean :draft, default: true
      t.timestamps
    end
  end
end
