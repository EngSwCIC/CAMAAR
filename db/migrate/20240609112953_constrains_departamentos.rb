class ConstrainsDepartamentos < ActiveRecord::Migration[6.0]
  def change
    change_column :departamentos, :nome, :string, null: false
    add_index :departamentos, :nome, unique: true
    end
  end

