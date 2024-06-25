class AddFieldsToTurmas < ActiveRecord::Migration[7.1]
  def change
    add_column :turmas, :codigo, :string
    add_column :turmas, :semestre, :string
    add_column :turmas, :horario, :string
  end
end
