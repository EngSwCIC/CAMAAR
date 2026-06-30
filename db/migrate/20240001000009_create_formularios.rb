class CreateFormularios < ActiveRecord::Migration[8.1]
  def change
    create_table :formularios do |t|
      t.bigint    :template_id,   null: false
      t.bigint    :turma_id,      null: false
      t.string    :publico_alvo,  limit: 20, null: false
      t.string    :status,        limit: 20, null: false
      t.timestamp :data_inicio
      t.timestamp :data_limite
      t.bigint    :criado_por_id, null: false

      t.timestamps
    end

    add_index :formularios, :template_id
    add_index :formularios, :turma_id
    add_index :formularios, :criado_por_id

    add_foreign_key :formularios, :templates, column: :template_id
    add_foreign_key :formularios, :turmas,    column: :turma_id
    add_foreign_key :formularios, :usuarios,  column: :criado_por_id
  end
end
