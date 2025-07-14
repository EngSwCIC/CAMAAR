class CorrigirValorPadraoFormularioAtivo < ActiveRecord::Migration[8.0]
  def change
    change_column_default :formularios, :ativo, false
  end
end
