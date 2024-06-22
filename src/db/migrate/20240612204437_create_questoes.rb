class CreateQuestoes < ActiveRecord::Migration[7.1]
  def change
    create_table :questoes do |t|
      t.string :tipo
      
      t.timestamps
    end
  end
end
