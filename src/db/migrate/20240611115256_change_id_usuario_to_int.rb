class ChangeIdUsuarioToInt < ActiveRecord::Migration[7.1]
  def change
    change_table :templates do |t|
      t.change :id_usuario, :integer
    end
  end
end
