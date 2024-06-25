class AddTextoToQuestaos < ActiveRecord::Migration[7.1]
  def change
    add_column :questaos, :texto, :string
  end
end
