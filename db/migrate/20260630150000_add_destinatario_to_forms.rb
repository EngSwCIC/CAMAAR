class AddDestinatarioToForms < ActiveRecord::Migration[8.1]
  def change
    add_column :forms, :destinatario, :string, default: "discente", null: false
  end
end
