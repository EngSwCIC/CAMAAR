class CreateResultado < ActiveRecord::Migration[7.1]
  def change
    create_table :resultados do |t|
      t.references :dicente, null: false, foreign_key: true
      t.references :formulario, null: false, foreign_key: true
      t.references :resposta, null: false, foreign_key: true
      t.references :questao, foreign_key: true

      t.timestamps
    end
  end
end
