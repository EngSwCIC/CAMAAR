class CreateProfessors < ActiveRecord::Migration[8.1]
  def change
    create_table :professors do |t|
      t.references :usuario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
