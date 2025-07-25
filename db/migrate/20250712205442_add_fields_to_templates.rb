class AddFieldsToTemplates < ActiveRecord::Migration[8.0]
  def change
    add_column :templates, :descricao, :text
    add_column :templates, :disciplina_id, :integer
    add_index :templates, :disciplina_id
    add_foreign_key :templates, :disciplinas
  end
end
