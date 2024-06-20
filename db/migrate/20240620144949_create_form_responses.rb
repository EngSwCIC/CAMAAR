class CreateFormResponses < ActiveRecord::Migration[7.1]
  def change
    create_table :form_responses do |t|
      t.belongs_to :study_class, null: false, foreign_key: true
      t.belongs_to :template, null: false, foreign_key: true
      t.string :response

      t.timestamps
    end
  end
end
