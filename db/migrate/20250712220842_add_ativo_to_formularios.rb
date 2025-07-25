class AddAtivoToFormularios < ActiveRecord::Migration[8.0]
  def change
    add_column :formularios, :ativo, :boolean
  end
end
