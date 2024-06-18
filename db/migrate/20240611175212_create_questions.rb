class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.string :type
      t.string :description
      t.string :label

      t.timestamps
    end
  end
end
