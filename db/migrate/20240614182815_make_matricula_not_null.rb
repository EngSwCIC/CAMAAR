class MakeMatriculaNotNull < ActiveRecord::Migration[7.1]
  def change
    change_column_null :users, :matricula, false, ""
  end
end
