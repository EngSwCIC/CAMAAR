class CreateForms < ActiveRecord::Migration[7.1]
  def change
    create_table :forms do |t|
      t.string :role, default: 'student'
      t.boolean :open, default: false
      t.string :name

      t.timestamps
    end
  end
end
