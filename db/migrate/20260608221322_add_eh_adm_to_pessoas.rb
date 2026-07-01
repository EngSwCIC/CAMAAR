class AddEhAdmToPessoas < ActiveRecord::Migration[7.1]
  def change
    add_column :pessoas, :ehAdm, :boolean
  end
end
