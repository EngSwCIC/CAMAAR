class AllowNullValuesInResposta < ActiveRecord::Migration[8.0]
  def change
    change_column_null :resposta, :opcao_id, true
    change_column_null :resposta, :turma_id, true
    change_column_null :resposta, :uuid_anonimo, false
  end
end
