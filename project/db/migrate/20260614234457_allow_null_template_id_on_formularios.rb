class AllowNullTemplateIdOnFormularios < ActiveRecord::Migration[8.1]
  def change
    change_column_null :formularios, :template_id, true
  end
end
