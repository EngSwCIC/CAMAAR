class AddDisciplinaToTurmas < ActiveRecord::Migration[7.1]
  def change
    add_reference :turmas, :disciplina, type: :string, null: false, foreign_key: { primary_key: :codigo }
  end
end
