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

ActiveRecord::Schema[8.1].define(version: 2026_05_27_131217) do
  create_table "cursos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nome", limit: 150, null: false
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_cursos_on_nome", unique: true
  end

  create_table "departamentos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nome", limit: 120, null: false
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_departamentos_on_nome", unique: true
  end

  create_table "disciplinas", force: :cascade do |t|
    t.string "codigo", limit: 30, null: false
    t.datetime "created_at", null: false
    t.string "nome", limit: 150, null: false
    t.datetime "updated_at", null: false
    t.index ["codigo"], name: "index_disciplinas_on_codigo", unique: true
  end

  create_table "formularios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "criado_por_id", null: false
    t.datetime "data_inicio"
    t.datetime "data_limite"
    t.string "publico_alvo", limit: 20, null: false
    t.string "status", limit: 20, null: false
    t.bigint "template_id", null: false
    t.bigint "turma_id", null: false
    t.datetime "updated_at", null: false
    t.index ["criado_por_id"], name: "index_formularios_on_criado_por_id"
    t.index ["template_id"], name: "index_formularios_on_template_id"
    t.index ["turma_id"], name: "index_formularios_on_turma_id"
  end

  create_table "matriculas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "papel_na_turma", limit: 20, null: false
    t.bigint "turma_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "usuario_id", null: false
    t.index ["turma_id", "usuario_id"], name: "index_matriculas_on_turma_id_and_usuario_id", unique: true
    t.index ["usuario_id"], name: "index_matriculas_on_usuario_id"
  end

  create_table "questoes_template", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "enunciado", null: false
    t.boolean "obrigatoria", default: true, null: false
    t.integer "ordem", null: false
    t.bigint "template_id", null: false
    t.string "tipo", limit: 20, null: false
    t.datetime "updated_at", null: false
    t.index ["template_id", "ordem"], name: "index_questoes_template_on_template_id_and_ordem", unique: true
  end

  create_table "resposta_itens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "questao_template_id", null: false
    t.bigint "resposta_id", null: false
    t.datetime "updated_at", null: false
    t.decimal "valor_numerico", precision: 10, scale: 2
    t.string "valor_opcao", limit: 100
    t.text "valor_texto"
    t.index ["questao_template_id"], name: "index_resposta_itens_on_questao_template_id"
    t.index ["resposta_id", "questao_template_id"], name: "index_resposta_itens_on_resposta_id_and_questao_template_id", unique: true
  end

  create_table "respostas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "enviado_em", null: false
    t.bigint "formulario_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "usuario_id", null: false
    t.index ["formulario_id", "usuario_id"], name: "index_respostas_on_formulario_id_and_usuario_id", unique: true
    t.index ["usuario_id"], name: "index_respostas_on_usuario_id"
  end

  create_table "templates", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.bigint "criador_id", null: false
    t.text "descricao"
    t.string "perfil_alvo"
    t.string "titulo", limit: 150, null: false
    t.datetime "updated_at", null: false
    t.integer "versao", default: 1, null: false
    t.index ["criador_id"], name: "index_templates_on_criador_id"
  end

  create_table "turmas", force: :cascade do |t|
    t.string "codigo_turma", limit: 40, null: false
    t.datetime "created_at", null: false
    t.bigint "departamento_id", null: false
    t.bigint "disciplina_id", null: false
    t.bigint "docente_id"
    t.string "semestre", limit: 10, null: false
    t.datetime "updated_at", null: false
    t.index ["codigo_turma", "semestre"], name: "index_turmas_on_codigo_turma_and_semestre", unique: true
    t.index ["departamento_id"], name: "index_turmas_on_departamento_id"
    t.index ["disciplina_id"], name: "index_turmas_on_disciplina_id"
    t.index ["docente_id"], name: "index_turmas_on_docente_id"
  end

  create_table "usuarios", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.bigint "curso_id"
    t.bigint "departamento_id"
    t.string "email", limit: 150, null: false
    t.string "matricula", limit: 30
    t.string "nome", limit: 150, null: false
    t.string "perfil", limit: 20, null: false
    t.string "reset_token"
    t.datetime "reset_token_sent_at"
    t.boolean "reset_token_used", default: false, null: false
    t.string "senha_hash", limit: 255, null: false
    t.string "setup_token"
    t.datetime "setup_token_sent_at"
    t.boolean "setup_token_used", default: false, null: false
    t.datetime "updated_at", null: false
    t.index ["curso_id"], name: "index_usuarios_on_curso_id"
    t.index ["departamento_id"], name: "index_usuarios_on_departamento_id"
    t.index ["email"], name: "index_usuarios_on_email", unique: true
    t.index ["matricula"], name: "index_usuarios_on_matricula", unique: true
  end

  add_foreign_key "formularios", "templates"
  add_foreign_key "formularios", "turmas"
  add_foreign_key "formularios", "usuarios", column: "criado_por_id"
  add_foreign_key "matriculas", "turmas"
  add_foreign_key "matriculas", "usuarios"
  add_foreign_key "questoes_template", "templates"
  add_foreign_key "resposta_itens", "questoes_template", column: "questao_template_id"
  add_foreign_key "resposta_itens", "respostas"
  add_foreign_key "respostas", "formularios"
  add_foreign_key "respostas", "usuarios"
  add_foreign_key "templates", "usuarios", column: "criador_id"
  add_foreign_key "turmas", "departamentos"
  add_foreign_key "turmas", "disciplinas"
  add_foreign_key "turmas", "usuarios", column: "docente_id"
  add_foreign_key "usuarios", "cursos"
  add_foreign_key "usuarios", "departamentos"
end
