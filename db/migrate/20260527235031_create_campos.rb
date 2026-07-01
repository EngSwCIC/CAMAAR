class CreateCampos < ActiveRecord::Migration[8.1]
  def change
    create_table :campos do |t|
      t.integer :ordem
      t.string :enunciado
      t.string :tipo_elemento
      t.references :elemento, null: false, foreign_key: true

      t.timestamps
    end
  end
end
