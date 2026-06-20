class FixTemplateFormularioCreatorReference < ActiveRecord::Migration[8.1]
  def up
    # Se já foi renomeado (criador_formulario_id existe), só garante a FK.
    if column_exists?(:template_formularios, :criador_formulario_id)
      unless foreign_key_exists?(:template_formularios, column: :criador_formulario_id)
        add_foreign_key :template_formularios, :criador_formularios
      end
      return
    end

    if foreign_key_exists?(:template_formularios, column: :criador_de_formulario_id)
      remove_foreign_key :template_formularios, column: :criador_de_formulario_id
    end

    rename_column :template_formularios, :criador_de_formulario_id, :criador_formulario_id
    add_foreign_key :template_formularios, :criador_formularios
  end

  def down
    remove_foreign_key :template_formularios, column: :criador_formulario_id, if_exists: true
    if column_exists?(:template_formularios, :criador_formulario_id)
      rename_column :template_formularios, :criador_formulario_id, :criador_de_formulario_id
    end
  end
end
