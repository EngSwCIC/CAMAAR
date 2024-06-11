class AddColumnsQuestaos < ActiveRecord::Migration[7.1]
  def change
    add_reference :questaos, :formulario, foreign_key: true
  end
end
