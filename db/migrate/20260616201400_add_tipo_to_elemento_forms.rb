class AddTipoToElementoForms < ActiveRecord::Migration[8.1]
  def change
    add_column :elemento_forms, :tipo, :string unless column_exists?(:elemento_forms, :tipo)
  end
end
