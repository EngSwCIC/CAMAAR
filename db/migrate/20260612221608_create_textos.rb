class CreateTextos < ActiveRecord::Migration[8.1]
  def change
    create_table :textos do |t|
      t.references :resposta,
        null: false,
        foreign_key: true,
        index: { unique: true }
      t.text :texto, null: false

      t.timestamps
    end
  end
end
