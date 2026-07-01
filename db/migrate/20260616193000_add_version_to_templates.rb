class AddVersionToTemplates < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:templates, :version)
      add_column :templates, :version, :integer, default: 1, null: false
      add_reference :templates, :parent_template, foreign_key: { to_table: :templates }
    end
  end
end