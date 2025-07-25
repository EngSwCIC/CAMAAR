# frozen_string_literal: true

# Migration to create cursos table
class CreateCursos < ActiveRecord::Migration[8.0]
  def change
    create_table :cursos do |t|
      t.string :nome

      t.timestamps
    end
  end
end
