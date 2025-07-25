class AddFieldsToDisciplinas < ActiveRecord::Migration[8.0]
  def change
    add_column :disciplinas, :codigo, :string
    add_column :disciplinas, :codigo_turma, :string
    add_column :disciplinas, :semestre, :string
    add_column :disciplinas, :horario, :string
  end
end
