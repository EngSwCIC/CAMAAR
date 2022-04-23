class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.integer :code
      t.references :survey, null: false, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
