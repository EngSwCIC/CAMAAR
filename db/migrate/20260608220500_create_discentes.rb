class CreateDiscentes < ActiveRecord::Migration[7.1]
  def change
    create_table :discentes do |t|
      t.string :curso
      t.string :matricula
      t.references :pessoa, type: :string, null: false, foreign_key: true

      t.timestamps
    end
  end
end
