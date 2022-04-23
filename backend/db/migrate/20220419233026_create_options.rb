class CreateOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :options do |t|
      t.text :option
      t.belongs_to :multiple_choice, foreign_key: true

      t.timestamps
    end
  end
end
