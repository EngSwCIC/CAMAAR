class AddDetalhesToPerguntaFormularios < ActiveRecord::Migration[8.1]
  def up
    add_column :pergunta_formularios, :tipo_pergunta, :integer unless column_exists?(:pergunta_formularios, :tipo_pergunta)
    add_column :pergunta_formularios, :enunciado, :text unless column_exists?(:pergunta_formularios, :enunciado)
    add_column :pergunta_formularios, :numero_opcoes, :integer unless column_exists?(:pergunta_formularios, :numero_opcoes)
    add_column :pergunta_formularios, :opcoes_radio, :json unless column_exists?(:pergunta_formularios, :opcoes_radio)
    add_column :pergunta_formularios, :gabarito_radio, :integer unless column_exists?(:pergunta_formularios, :gabarito_radio)
    add_column :pergunta_formularios, :gabarito_discursiva, :text unless column_exists?(:pergunta_formularios, :gabarito_discursiva)

    remove_foreign_key :pergunta_formularios, :perguntas, if_exists: true
    remove_foreign_key :pergunta_formularios, :pergunta, if_exists: true

    change_column_null :pergunta_formularios, :pergunta_id, true

    add_foreign_key :pergunta_formularios, :pergunta, column: :pergunta_id, on_delete: :nullify
  end

  def down
    remove_foreign_key :pergunta_formularios, :pergunta, if_exists: true
    remove_column :pergunta_formularios, :tipo_pergunta if column_exists?(:pergunta_formularios, :tipo_pergunta)
    remove_column :pergunta_formularios, :enunciado if column_exists?(:pergunta_formularios, :enunciado)
    remove_column :pergunta_formularios, :numero_opcoes if column_exists?(:pergunta_formularios, :numero_opcoes)
    remove_column :pergunta_formularios, :opcoes_radio if column_exists?(:pergunta_formularios, :opcoes_radio)
    remove_column :pergunta_formularios, :gabarito_radio if column_exists?(:pergunta_formularios, :gabarito_radio)
    remove_column :pergunta_formularios, :gabarito_discursiva if column_exists?(:pergunta_formularios, :gabarito_discursiva)
  end
end
