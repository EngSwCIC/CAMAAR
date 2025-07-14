# frozen_string_literal: true

class CreateResposta < ActiveRecord::Migration[8.0]
  def change
    create_table :resposta do |t|
      t.references :formulario, null: false, foreign_key: true
      t.references :pergunta, null: false, foreign_key: true
      t.references :opcao, null: false, foreign_key: true
      t.text :resposta_texto
      t.references :turma, null: false, foreign_key: true
      t.string :uuid_anonimo

      t.timestamps
    end
  end
end
