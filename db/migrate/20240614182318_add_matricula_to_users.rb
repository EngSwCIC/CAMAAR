class AddMatriculaToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :matricula, :string
    add_index :users, :matricula, unique: true
  end
end
