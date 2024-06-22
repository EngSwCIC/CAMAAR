class RemoveIsAdminFromAlunos < ActiveRecord::Migration[7.1]
  def change
    remove_column :alunos, :is_admin, :boolean
  end
end
