class FixForeignKeys < ActiveRecord::Migration[8.0]
  def change
    # Remove foreign keys incorretos
    remove_foreign_key "formularios", "coordenadors"
    remove_foreign_key "resposta", "opcaos"
    remove_foreign_key "templates", "criado_pors"
    remove_foreign_key "turmas", "professors"
    
    # Adiciona foreign keys corretos
    add_foreign_key "formularios", "users", column: "coordenador_id"
    add_foreign_key "resposta", "opcoes_pergunta", column: "opcao_id"
    add_foreign_key "templates", "users", column: "criado_por_id"
    add_foreign_key "turmas", "users", column: "professor_id"
  end
end
