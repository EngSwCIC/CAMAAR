class CreateTemplates < ActiveRecord::Migration[8.0]
  def change
    create_table :templates do |t|
      t.references :ligacao_pergunta, null: false, foreign_key: true
      t.string :nome, null: false

      t.timestamps
    end
  end
end
