class CreateAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :answers do |t|
      t.integer :alternative_answer
      t.references :member, null: false, foreign_key: true
      t.references :option, null: false, foreign_key: true
      t.timestamps
    end
  end
end
