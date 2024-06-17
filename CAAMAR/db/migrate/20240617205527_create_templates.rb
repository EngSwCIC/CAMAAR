class CreateTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :templates do |t|
      t.string :subject
      t.integer :semester
      t.string :professor

      t.timestamps
    end
  end
end
