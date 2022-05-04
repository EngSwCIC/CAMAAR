class CreateAvaliations < ActiveRecord::Migration[7.0]
  def change
    create_table :avaliations do |t|
      t.references :cclass, null: false, foreign_key: true
      t.string :title
      t.timestamps
    end
  end
end
