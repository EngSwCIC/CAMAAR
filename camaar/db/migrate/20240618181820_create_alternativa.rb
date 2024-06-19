class CreateAlternativa < ActiveRecord::Migration[7.1]
  def change
    create_table :alternativas do |t|
      t.references :questao, null: false, foreign_key: true
      t.string :texto, null: false

      t.timestamps
    end
  end
end
