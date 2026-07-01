class CreateQuestoes < ActiveRecord::Migration[8.1]
  def change
    create_table :questoes do |t|
      t.text :enunciado, null: false
      t.integer :tipo, null: false

      t.timestamps
    end
  end
end
