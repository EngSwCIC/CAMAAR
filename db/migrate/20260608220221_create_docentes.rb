class CreateDocentes < ActiveRecord::Migration[7.1]
  def change
    create_table :docentes do |t|
      t.string :departamento
      t.references :pessoa, type: :string, null: false, foreign_key: true

      t.timestamps
    end
  end
end
