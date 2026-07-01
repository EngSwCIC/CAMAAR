class CreateSigaaLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :sigaa_logs do |t|
      t.string :status
      t.text :message
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end