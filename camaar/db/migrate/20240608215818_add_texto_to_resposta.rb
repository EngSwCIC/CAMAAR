class AddTextoToResposta < ActiveRecord::Migration[7.1]
  def change
    add_column :resposta, :texto, :string
  end
end
