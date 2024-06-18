class AddFkToTables < ActiveRecord::Migration[7.1]
  def change
    add_reference :templates, :users, foreign_key: true
    add_reference :questoes, :respostas, foreign_key: true
    add_reference :formularios, :respostas, foreign_key: true
    add_reference :users, :respostas, foreign_key: true

  end
end
