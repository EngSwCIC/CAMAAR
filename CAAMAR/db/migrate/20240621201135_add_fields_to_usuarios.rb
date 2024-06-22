class AddFieldsToUsuarios < ActiveRecord::Migration[7.1]
  def change
    add_column :usuarios, :isAdmin, :boolean
    add_column :usuarios, :isAluno, :boolean
    add_column :usuarios, :isProf, :boolean
    add_column :usuarios, :curso, :string
    add_column :usuarios, :departamento, :string
  end
end
