class AddNomeToFormularios < ActiveRecord::Migration[7.1]
  def change
    add_column :formularios, :nome, :string
  end
end
