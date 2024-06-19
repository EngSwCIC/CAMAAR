class CreateDicente < ActiveRecord::Migration[7.1]
  def change
    create_table :dicentes do |t|
      t.string :curso, null: false
      t.string :matricula, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
