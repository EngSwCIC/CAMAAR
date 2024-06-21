class AddTimeFieldTurma < ActiveRecord::Migration[7.1]
  def change
    add_column :turmas, :horario, :string
  end
end
