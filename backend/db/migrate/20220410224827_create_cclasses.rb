class CreateCclasses < ActiveRecord::Migration[7.0]
  def change
    create_table :cclasses do |t|
      t.string :code
      t.string :semester
      t.string :time

      t.references :subject, null: false, foreign_key: true
      t.timestamps
    end
  end
end
