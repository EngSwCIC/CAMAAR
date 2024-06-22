class AddReferencesToQuestaos < ActiveRecord::Migration[7.1]
  def change
    add_reference :questaos, :formularios, null: false, foreign_key: true
    add_reference :questaos, :templates, null: false, foreign_key: true
  end
end
