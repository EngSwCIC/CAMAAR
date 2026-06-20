class CreateEstudantes < ActiveRecord::Migration[8.1]
  def change
    create_table :estudantes do |t|
      t.references :usuario, null: false, foreign_key: true
      t.string :matricula

      t.timestamps
    end
  end
end
