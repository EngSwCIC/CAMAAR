class ConsolidateToUserModel < ActiveRecord::Migration[8.1]
  def up
    # --- course_classes: horário para exibição ---
    add_column :course_classes, :time, :string

    # --- formularios: turma_id → course_class_id ---
    remove_foreign_key :formularios, column: :turma_id
    rename_column :formularios, :turma_id, :course_class_id
    add_foreign_key :formularios, :course_classes, column: :course_class_id

    # --- submissaos: substituir polimórfico por user_id ---
    remove_column :submissaos, :participant_id
    remove_column :submissaos, :participant_type
    add_reference :submissaos, :user, null: false, foreign_key: true

    # --- remover tabelas legadas (ordem respeita FKs) ---
    drop_table :turma_alunos
    drop_table :turmas
    drop_table :professors
    drop_table :admins
    drop_table :alunos
    drop_table :departamentos
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
