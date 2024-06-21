class AddMatriculaDefault < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :matricula, ""
  end
end
