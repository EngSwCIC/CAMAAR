class RemoveTemplateUsadoFromFormularios < ActiveRecord::Migration[7.1]
  def change
    remove_column :formularios, :template_usado, :integer
  end
end
