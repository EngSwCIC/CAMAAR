class RenameRegistrationNumberAndRoleToMatriculaAndOcupacao < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :registration_number, :matricula
    rename_column :users, :role, :ocupacao

    # Adicione isso se a coluna role não for string
    change_column :users, :ocupacao, :string, default: 'discente'
  end
end