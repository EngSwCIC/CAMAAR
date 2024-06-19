class CreateForms < ActiveRecord::Migration[7.1]
  def change
    create_table :forms do |t|
      t.references :template, foreign_key: true
      t.references :questions, foreign_key: true
      t.references :semester, null: false, foreign_key: true

      t.timestamps
    end
  end
end
