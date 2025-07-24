class CreateTemplateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :template_questions do |t|
      t.references :template, null: false, foreign_key: true
      t.text :question_text, null: false
      t.string :question_type, null: false # 'text', 'radio', 'checkbox', 'scale'
      t.text :options # JSON para opções de radio/checkbox
      t.boolean :required, default: false
      t.integer :position, default: 0
      t.timestamps
    end

    add_index :template_questions, [ :template_id, :position ]
  end
end
