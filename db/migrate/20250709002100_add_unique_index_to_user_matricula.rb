# frozen_string_literal: true

# Migration to add unique index to matricula column
class AddUniqueIndexToUserMatricula < ActiveRecord::Migration[8.0]
  def change
    add_index :users, :matricula, unique: true
  end
end
