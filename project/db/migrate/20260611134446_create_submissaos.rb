class CreateSubmissaos < ActiveRecord::Migration[8.1]
  def change
    create_table :submissaos do |t|
      t.references :formulario, null: false, foreign_key: true
      t.references :participant, polymorphic: true, null: false

      t.timestamps
    end
  end
end
