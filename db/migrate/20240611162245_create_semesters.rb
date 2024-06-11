class CreateSemesters < ActiveRecord::Migration[7.1]
  def change
    create_table :semesters do |t|
      t.boolean :half
      t.integer :year

      t.timestamps
    end
  end
end
