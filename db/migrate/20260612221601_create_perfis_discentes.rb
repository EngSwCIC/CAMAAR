# frozen_string_literal: true

class CreatePerfisDiscentes < ActiveRecord::Migration[8.1]
  def change
    create_table :perfis_discentes, id: false do |t|
      t.primary_key :id

      t.timestamps
    end

    add_foreign_key :perfis_discentes, :usuarios, column: :id
  end
end
