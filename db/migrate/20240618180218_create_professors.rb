class CreateProfessors < ActiveRecord::Migration[6.0]
  def change
    create_table :professors do |t|
      t.string :registration_number, null: false
      t.string :name, null: false 
      t.string :department_code, null: false

      t.timestamps
    end
    add_index :professors, :registration_number, unique: true
  end
end
