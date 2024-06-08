class AddReferencesToFormularios < ActiveRecord::Migration[7.1]
  def change
    add_reference :formularios, :turma, null: false, foreign_key: true
    add_reference :formularios, :template, null: false, foreign_key: true
  end
end
