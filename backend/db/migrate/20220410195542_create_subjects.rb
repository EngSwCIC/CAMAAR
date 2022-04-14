class CreateSubjects < ActiveRecord::Migration[7.0]
  def change
    create_table :subjects do |t|
      t.string :code, null: false
      t.string :name, null: false

      t.timestamps
    end
    add_index :subjects, :code, unique: true
    add_index :subjects, :name, unique: true
  end
end
