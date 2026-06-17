class CreateImportInconsistencies < ActiveRecord::Migration[8.1]
  def change
    create_table :import_inconsistencies do |t|
      t.string :source, null: false
      t.string :message, null: false
      t.json :payload

      t.timestamps
    end
  end
end
