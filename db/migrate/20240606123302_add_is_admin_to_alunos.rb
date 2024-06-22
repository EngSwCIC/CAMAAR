class AddIsAdminToAlunos < ActiveRecord::Migration[7.1]
  def change
    add_column :alunos, :is_admin, :boolean
  end
end
