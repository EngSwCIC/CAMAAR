class CreateTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :templates do |t|
      t.references :semester, null: true, foreign_key: true
      t.references :questions, null: true, foreign_key: true

      t.timestamps
    end
  end
end
