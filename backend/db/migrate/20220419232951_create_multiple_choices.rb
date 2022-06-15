class CreateMultipleChoices < ActiveRecord::Migration[7.0]
  def change
    create_table :multiple_choices do |t|
      t.belongs_to :survey_question, foreign_key: true

      t.timestamps
    end
  end
end
