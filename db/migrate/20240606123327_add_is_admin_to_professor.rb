class AddIsAdminToProfessor < ActiveRecord::Migration[7.1]
  def change
    add_column :professors, :is_admin, :boolean
  end
end
