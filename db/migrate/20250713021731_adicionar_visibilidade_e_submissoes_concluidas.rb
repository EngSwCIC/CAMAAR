class AdicionarVisibilidadeESubmissoesConcluidas < ActiveRecord::Migration[8.0]
  def up
    # Adiciona colunas de visibilidade à tabela formularios
    add_column :formularios, :escopo_visibilidade, :integer, default: 0, null: false
    add_column :formularios, :disciplina_id, :integer, null: true

    # Torna a coluna turma_id opcional
    change_column_null :formularios, :turma_id, true

    # Adiciona índices para otimizar consultas
    add_index :formularios, :escopo_visibilidade
    add_index :formularios, :disciplina_id
    add_index :formularios, %i[escopo_visibilidade disciplina_id]

    # Adiciona foreign key para disciplina_id
    add_foreign_key :formularios, :disciplinas, column: :disciplina_id

    # Cria tabela submissoes_concluidas
    create_table :submissoes_concluidas do |t|
      t.references :user, null: false, foreign_key: true
      t.references :formulario, null: false, foreign_key: true

      t.timestamps
    end

    # Adiciona índice único composto para evitar duplicatas
    add_index :submissoes_concluidas, %i[user_id formulario_id], unique: true,
                                                                 name: 'index_submissoes_concluidas_unique'
  end

  def down
    # Remove tabela submissoes_concluidas
    drop_table :submissoes_concluidas

    # Remove foreign key e índices de disciplina_id
    remove_foreign_key :formularios, :disciplinas
    remove_index :formularios, %i[escopo_visibilidade disciplina_id]
    remove_index :formularios, :disciplina_id
    remove_index :formularios, :escopo_visibilidade

    # Remove colunas adicionadas
    remove_column :formularios, :disciplina_id
    remove_column :formularios, :escopo_visibilidade

    # Reverte turma_id para not null
    change_column_null :formularios, :turma_id, false
  end
end
