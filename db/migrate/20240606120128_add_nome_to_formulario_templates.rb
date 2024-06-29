class AddNomeToFormularioTemplates < ActiveRecord::Migration[7.1]
  def change
    add_column :formulario_templates, :nome, :string
  end
end
