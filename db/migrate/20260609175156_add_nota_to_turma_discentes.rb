class AddNotaToTurmaDiscentes < ActiveRecord::Migration[7.1]
  def change
    add_column :turma_discentes, :nota, :float
  end
end
