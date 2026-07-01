class AddFormularioToQuestoes < ActiveRecord::Migration[8.1]
  def change
    add_reference :questoes, :formulario, foreign_key: true, null: true
  end
end
