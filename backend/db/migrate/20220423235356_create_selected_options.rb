class CreateSelectedOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :selected_options do |t|
      t.string :custom_option
      t.references :option, null: false, foreign_key: true
      t.references :answer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
