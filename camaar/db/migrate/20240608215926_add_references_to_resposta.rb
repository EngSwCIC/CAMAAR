class AddReferencesToResposta < ActiveRecord::Migration[7.1]
  def change
    add_reference :resposta, :questao, null: false, foreign_key: true
    add_reference :resposta, :formulario, null: false, foreign_key: true
  end
end
