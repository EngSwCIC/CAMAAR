class CreateTemplateResponses < ActiveRecord::Migration[8.0]
  def change
    create_table :template_responses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :template, null: false, foreign_key: true
      t.datetime :submitted_at
      t.timestamps
    end

    add_index :template_responses, [ :user_id, :template_id ], unique: true
  end
end
