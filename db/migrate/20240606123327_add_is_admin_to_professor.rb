class AddIsAdminToProfessor < ActiveRecord::Migration[7.1]
  def change
    add_column :professors, :isadmin, :boolean
  end
end
