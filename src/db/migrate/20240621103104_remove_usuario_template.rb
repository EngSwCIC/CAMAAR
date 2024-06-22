class RemoveUsuarioTemplate < ActiveRecord::Migration[7.1]
  def change
    remove_column :templates, :usuario
  end
end
