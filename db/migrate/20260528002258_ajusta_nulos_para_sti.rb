class AjustaNulosParaSti < ActiveRecord::Migration[8.1]
  def change
    change_column_null :usuarios, :curso_id, true
    change_column_null :usuarios, :departamento_id, true
    change_column_null :resposta_elems, :campo_form_id, true
  end
end
