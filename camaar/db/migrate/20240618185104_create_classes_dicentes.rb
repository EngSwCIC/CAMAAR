class CreateClassesDicentes < ActiveRecord::Migration[7.1]
  def change
    create_table :classes_dicentes do |t|
      t.references :classe, null: false, foreign_key: true
      t.references :dicente, null: false, foreign_key: true

      t.timestamps
    end
  end
end
