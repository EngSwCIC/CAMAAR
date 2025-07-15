class AddocupacaoAndRegistrationNumberToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :ocupacao, :string, default: 'discente'
    add_column :users, :matricula, :string

    add_index :users, :matricula, unique: true
    add_index :users, :ocupacao
  end
end