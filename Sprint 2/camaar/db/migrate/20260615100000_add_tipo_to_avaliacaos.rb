class AddTipoToAvaliacaos < ActiveRecord::Migration[7.1]
  def change
    add_column :avaliacaos, :tipo, :string, null: false, default: 'discente'
  end
end
