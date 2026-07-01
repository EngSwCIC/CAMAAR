class AddUsuarioToTemplates < ActiveRecord::Migration[8.1]
  def change
    add_reference :templates, :usuario, null: false, foreign_key: true
  end
end
