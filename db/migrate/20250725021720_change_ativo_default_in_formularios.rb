class ChangeAtivoDefaultInFormularios < ActiveRecord::Migration[8.0]
  def change
    change_column_default :formularios, :ativo, from: false, to: true
  end
end
