class ChangeOcupacaoTypeToStringOnUsers < ActiveRecord::Migration[8.0]
  def up
    change_column :users, :ocupacao, :string
  end

  def down
    change_column :users, :ocupacao, :integer
  end
end
