class ChangeOcupacaoToEnum < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :ocupacao, :string
  end
end