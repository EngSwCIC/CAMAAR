class CreateQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :questions do |t|
      t.references :template, null: false, foreign_key: true
      t.string :kind, null: false
      t.text :text, null: false
      t.timestamps
    end
  end
end
