# frozen_string_literal: true

class CriarEstruturaInicialParaAutenticacao < ActiveRecord::Migration[8.1]
  def change
    create_table :tokens do |t|
      t.references :usuario, null: false, foreign_key: true
      t.string :value, null: false
      t.string :tipo, null: false
      t.datetime :expires_at, null: false

      t.timestamps
    end

    add_index :tokens, :value, unique: true
    add_index :tokens, %i[usuario_id tipo]
  end
end
