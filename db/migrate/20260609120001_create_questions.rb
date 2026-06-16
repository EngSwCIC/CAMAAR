class CreateQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :questions do |t|
      t.references :template, null: false, foreign_key: true
      t.text :enunciado, null: false
      t.string :tipo, null: false, default: "discursiva"
      t.text :opcoes

      t.timestamps
    end
  end
end
