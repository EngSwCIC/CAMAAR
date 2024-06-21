class CreateFormRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :form_requests do |t|
      t.belongs_to :study_class, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.boolean :answered, null: false, default: false

      t.timestamps
    end
  end
end
