class AllowNullPerguntaIdOnPerguntaFormularios < ActiveRecord::Migration[8.1]
  def up
    # add_detalhes já executou change_column_null — esta migration é no-op idempotente.
    change_column_null :pergunta_formularios, :pergunta_id, true
  end

  def down
    change_column_null :pergunta_formularios, :pergunta_id, false
  end
end
