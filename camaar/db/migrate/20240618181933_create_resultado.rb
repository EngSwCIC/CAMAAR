class CreateResultado < ActiveRecord::Migration[7.1]
  def change
    create_table :resultados do |t|
      t.references :dicente, null: false, foreign_key: true
      t.references :formulario, null: false, foreign_key: true
      t.float :nota, null: false

      t.timestamps
    end
  end
end
