class AddTituloToFormulariosAndMakeTurmaOptional < ActiveRecord::Migration[8.1]
  def change
    add_column :formularios, :titulo, :string unless column_exists?(:formularios, :titulo)
    change_column_null :formularios, :turma_id, true
  end
end
