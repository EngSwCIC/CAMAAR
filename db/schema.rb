# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_20_191000) do
  create_table "avaliacoes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "formulario_id", null: false
    t.integer "participacao_turma_id", null: false
    t.datetime "respondido_em"
    t.integer "responida", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["formulario_id"], name: "index_avaliacoes_on_formulario_id"
    t.index ["participacao_turma_id", "formulario_id"], name: "index_avaliacoes_on_participacao_turma_id_and_formulario_id", unique: true
    t.index ["participacao_turma_id"], name: "index_avaliacoes_on_participacao_turma_id"
  end

  create_table "departamentos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nome", null: false
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_departamentos_on_nome", unique: true
  end

  create_table "formularios", force: :cascade do |t|
    t.integer "adm_id", null: false
    t.datetime "created_at", null: false
    t.datetime "criado_em", null: false
    t.integer "publico_alvo", null: false
    t.integer "template_id"
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
    t.index ["adm_id"], name: "index_formularios_on_adm_id"
    t.index ["template_id"], name: "index_formularios_on_template_id"
    t.index ["turma_id", "template_id", "publico_alvo"], name: "index_formularios_on_turma_id_and_template_id_and_publico_alvo", unique: true
    t.index ["turma_id"], name: "index_formularios_on_turma_id"
  end

  create_table "materias", force: :cascade do |t|
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.integer "departamento_id", null: false
    t.string "nome", null: false
    t.datetime "updated_at", null: false
    t.index ["codigo"], name: "index_materias_on_codigo", unique: true
    t.index ["departamento_id"], name: "index_materias_on_departamento_id"
  end

  create_table "opcoes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "numero", null: false
    t.integer "questao_id", null: false
    t.text "texto", null: false
    t.datetime "updated_at", null: false
    t.index ["questao_id", "numero"], name: "index_opcoes_on_questao_id_and_numero", unique: true
    t.index ["questao_id"], name: "index_opcoes_on_questao_id"
  end

  create_table "opcoes_escolhidas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "opcao_id", null: false
    t.integer "resposta_id", null: false
    t.datetime "updated_at", null: false
    t.index ["opcao_id"], name: "index_opcoes_escolhidas_on_opcao_id"
    t.index ["resposta_id", "opcao_id"], name: "index_opcoes_escolhidas_on_resposta_id_and_opcao_id", unique: true
    t.index ["resposta_id"], name: "index_opcoes_escolhidas_on_resposta_id"
  end

  create_table "participacoes_turmas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "tipo_participacao", null: false
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
    t.integer "usuario_id", null: false
    t.index ["turma_id"], name: "index_participacoes_turmas_on_turma_id"
    t.index ["usuario_id", "turma_id", "tipo_participacao"], name: "idx_on_usuario_id_turma_id_tipo_participacao_a374668730", unique: true
    t.index ["usuario_id"], name: "index_participacoes_turmas_on_usuario_id"
  end

  create_table "perfis_adm", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "departamento_id", null: false
    t.datetime "updated_at", null: false
    t.index ["departamento_id"], name: "index_perfis_adm_on_departamento_id"
  end

  create_table "perfis_discentes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "perfis_docentes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "departamento_id", null: false
    t.datetime "updated_at", null: false
    t.index ["departamento_id"], name: "index_perfis_docentes_on_departamento_id"
  end

  create_table "questoes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "enunciado", null: false
    t.integer "formulario_id"
    t.integer "tipo", null: false
    t.datetime "updated_at", null: false
    t.index ["formulario_id"], name: "index_questoes_on_formulario_id"
  end

  create_table "respostas", force: :cascade do |t|
    t.integer "avaliacao_id", null: false
    t.datetime "created_at", null: false
    t.integer "questao_id", null: false
    t.datetime "updated_at", null: false
    t.index ["avaliacao_id"], name: "index_respostas_on_avaliacao_id"
    t.index ["questao_id", "avaliacao_id"], name: "index_respostas_on_questao_id_and_avaliacao_id", unique: true
    t.index ["questao_id"], name: "index_respostas_on_questao_id"
  end

  create_table "templates", force: :cascade do |t|
    t.integer "adm_id", null: false
    t.datetime "created_at", null: false
    t.datetime "criado_em", null: false
    t.text "descricao"
    t.string "titulo", null: false
    t.datetime "updated_at", null: false
    t.index ["adm_id", "titulo"], name: "index_templates_on_adm_id_and_titulo", unique: true
    t.index ["adm_id"], name: "index_templates_on_adm_id"
  end

  create_table "textos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "resposta_id", null: false
    t.text "texto", null: false
    t.datetime "updated_at", null: false
    t.index ["resposta_id"], name: "index_textos_on_resposta_id", unique: true
  end

  create_table "tokens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "tipo", null: false
    t.datetime "updated_at", null: false
    t.integer "usuario_id", null: false
    t.string "value", null: false
    t.index ["usuario_id", "tipo"], name: "index_tokens_on_usuario_id_and_tipo"
    t.index ["usuario_id"], name: "index_tokens_on_usuario_id"
    t.index ["value"], name: "index_tokens_on_value", unique: true
  end

  create_table "turmas", force: :cascade do |t|
    t.integer "ano", null: false
    t.datetime "created_at", null: false
    t.integer "materia_id", null: false
    t.integer "numero", null: false
    t.integer "semestre", null: false
    t.datetime "updated_at", null: false
    t.index ["materia_id", "ano", "semestre", "numero"], name: "index_turmas_on_materia_id_and_ano_and_semestre_and_numero", unique: true
    t.index ["materia_id"], name: "index_turmas_on_materia_id"
  end

  create_table "usuarios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "matricula", null: false
    t.string "nome", null: false
    t.string "senha_digest"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_usuarios_on_email", unique: true
    t.index ["matricula"], name: "index_usuarios_on_matricula", unique: true
  end

  create_table "utilizacoes_questoes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "numero", null: false
    t.integer "parent_id"
    t.integer "questao_id", null: false
    t.integer "template_id", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_utilizacoes_questoes_on_parent_id"
    t.index ["questao_id"], name: "index_utilizacoes_questoes_on_questao_id"
    t.index ["template_id", "numero"], name: "index_utilizacoes_questoes_on_template_id_and_numero", unique: true, where: "parent_id IS NULL"
    t.index ["template_id", "parent_id", "numero"], name: "idx_on_template_id_parent_id_numero_d7bb201bb5", unique: true, where: "parent_id IS NOT NULL"
    t.index ["template_id", "parent_id", "questao_id"], name: "idx_on_template_id_parent_id_questao_id_960c40742a", unique: true, where: "parent_id IS NOT NULL"
    t.index ["template_id", "questao_id"], name: "index_utilizacoes_questoes_on_template_id_and_questao_id", unique: true, where: "parent_id IS NULL"
    t.index ["template_id"], name: "index_utilizacoes_questoes_on_template_id"
  end

  add_foreign_key "avaliacoes", "formularios"
  add_foreign_key "avaliacoes", "participacoes_turmas"
  add_foreign_key "formularios", "perfis_adm", column: "adm_id"
  add_foreign_key "formularios", "templates"
  add_foreign_key "formularios", "turmas"
  add_foreign_key "materias", "departamentos"
  add_foreign_key "opcoes", "questoes"
  add_foreign_key "opcoes_escolhidas", "opcoes"
  add_foreign_key "opcoes_escolhidas", "respostas"
  add_foreign_key "participacoes_turmas", "turmas"
  add_foreign_key "participacoes_turmas", "usuarios"
  add_foreign_key "perfis_adm", "departamentos"
  add_foreign_key "perfis_adm", "usuarios", column: "id"
  add_foreign_key "perfis_discentes", "usuarios", column: "id"
  add_foreign_key "perfis_docentes", "departamentos"
  add_foreign_key "perfis_docentes", "usuarios", column: "id"
  add_foreign_key "questoes", "formularios"
  add_foreign_key "respostas", "avaliacoes"
  add_foreign_key "respostas", "questoes"
  add_foreign_key "templates", "perfis_adm", column: "adm_id"
  add_foreign_key "textos", "respostas"
  add_foreign_key "tokens", "usuarios"
  add_foreign_key "turmas", "materias"
  add_foreign_key "utilizacoes_questoes", "questoes"
  add_foreign_key "utilizacoes_questoes", "templates"
  add_foreign_key "utilizacoes_questoes", "utilizacoes_questoes", column: "parent_id"
end
