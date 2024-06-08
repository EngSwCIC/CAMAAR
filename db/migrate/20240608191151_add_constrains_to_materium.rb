class AddConstrainsToMaterium < ActiveRecord::Migration[7.1]
  def change
    change_column_null :materium, :nome, false
    change_column_null :materium, :codigo, false
    change_column_null :materium, :departamento_id, false
    change_column_null :materium, :alunos_id, false
    change_column_null :materium, :professors_id, false
    change_column_null :alunos, :materium_id, false

  end
end
