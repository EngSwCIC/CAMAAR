class CreateFormResponses < ActiveRecord::Migration[8.1]
  def change
    create_table :form_responses do |t|
      t.references :form, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :turma, null: false, foreign_key: true
      t.text :answers
      t.timestamps
    end
  end
end
