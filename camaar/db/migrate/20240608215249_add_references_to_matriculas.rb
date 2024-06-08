class AddReferencesToMatriculas < ActiveRecord::Migration[7.1]
  def change
    add_reference :matriculas, :turma, null: false, foreign_key: true
  end
end
