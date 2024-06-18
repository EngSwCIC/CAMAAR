class CreateDocente < ActiveRecord::Migration[7.1]
  def change
    create_table :docentes do |t|
      t.string :departamento, null:false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
