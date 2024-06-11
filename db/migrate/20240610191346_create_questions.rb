class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.string :text
      t.string :type
      t.belongs_to :template, null: false, foreign_key: true

      t.timestamps
    end
  end
end
