class AddColumnsAdministradors < ActiveRecord::Migration[7.1]
  def change
    add_column :administradors, :nomes_turmas, :text, array: true, default: []
    add_column :administradors, :nomes_templates, :text, array: true, default: []
    add_column :administradors, :nomes_formularios, :text, array: true, default: []
  end
end
# neste caso estou salvando o array sem usar um json para comparar e ver qual é melhor, caso a diferença seja notável
