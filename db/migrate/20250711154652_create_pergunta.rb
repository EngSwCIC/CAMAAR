# frozen_string_literal: true

class CreatePergunta < ActiveRecord::Migration[8.0]
  def change
    create_table :pergunta do |t|
      t.references :template, null: false, foreign_key: true
      t.string :titulo
      t.integer :tipo
      t.integer :ordem

      t.timestamps
    end
  end
end
