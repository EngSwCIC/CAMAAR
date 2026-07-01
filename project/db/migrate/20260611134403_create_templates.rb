class CreateTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :templates do |t|
      t.string :title
      t.string :target_role
      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
