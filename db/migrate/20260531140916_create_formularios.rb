class CreateFormularios < ActiveRecord::Migration[8.1]
  def up
    return if table_exists?(:formularios) && column_exists?(:formularios, :template_formulario_id)
    drop_table :formularios if table_exists?(:formularios)
    create_table :formularios do |t|
      t.string :nome_formulario
      t.float :nota_final
      t.float :nota_media
      t.boolean :publico_estudante
      t.references :template_formulario, null: false, foreign_key: true
      t.references :turma, null: false, foreign_key: true
      t.references :criador_formulario, null: false, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :formularios, if_exists: true
  end
end
