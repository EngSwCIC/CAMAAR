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

ActiveRecord::Schema[8.1].define(version: 2026_06_16_231812) do

  # ── Autenticação (sprint 2) ─────────────────────────────────────────────────
  create_table "users", force: :cascade do |t|
    t.string   "email",          null: false
    t.string   "matricula",      null: false
    t.string   "nome",           null: false
    t.string   "password_digest"
    t.string   "perfil",         null: false
    t.boolean  "primeiro_acesso", default: true, null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["email"],     name: "index_users_on_email",     unique: true
    t.index ["matricula"], name: "index_users_on_matricula", unique: true
  end

  # ── Modelo original BDD (sprint 1) ─────────────────────────────────────────
  create_table "usuarios", force: :cascade do |t|
    t.string   "login",          null: false
    t.string   "password_digest", null: false
    t.string   "email",          null: false
    t.string   "nome",           null: false
    t.integer  "perfil",         null: false, default: 0
    t.boolean  "primeiro_acesso", null: false, default: true
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["login"], name: "index_usuarios_on_login", unique: true
    t.index ["email"], name: "index_usuarios_on_email", unique: true
  end

  # ── Estrutura organizacional ────────────────────────────────────────────────
  create_table "departamentos", force: :cascade do |t|
    t.string   "nome",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_departamentos_on_nome", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.integer  "user_id",        null: false
    t.integer  "departamento_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["departamento_id"], name: "index_admins_on_departamento_id"
    t.index ["user_id", "departamento_id"], name: "index_admins_on_user_id_and_departamento_id", unique: true
    t.index ["user_id"], name: "index_admins_on_user_id"
  end

  create_table "disciplinas", force: :cascade do |t|
    t.string   "codigo", null: false
    t.string   "nome",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codigo"], name: "index_disciplinas_on_codigo", unique: true
  end

  create_table "docentes", force: :cascade do |t|
    t.integer  "usuario_id",     null: false
    t.integer  "departamento_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "discentes", force: :cascade do |t|
    t.integer  "usuario_id", null: false
    t.string   "matricula",  null: false
    t.string   "curso",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matricula"], name: "index_discentes_on_matricula", unique: true
  end

  create_table "turmas", force: :cascade do |t|
    t.string   "codigo",         null: false
    t.string   "nome",           null: false
    t.string   "semestre"
    t.string   "horario"
    t.integer  "departamento_id", null: false
    t.integer  "disciplina_id"
    t.integer  "docente_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["departamento_id"], name: "index_turmas_on_departamento_id"
  end

  create_table "matriculas", force: :cascade do |t|
    t.integer  "discente_id", null: false
    t.integer  "turma_id",    null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["discente_id", "turma_id"], name: "index_matriculas_on_discente_id_and_turma_id", unique: true
  end

  # ── Templates e formulários ─────────────────────────────────────────────────
  create_table "templates", force: :cascade do |t|
    t.string   "titulo",     null: false
    t.text     "descricao"
    t.integer  "docente_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questao_templates", force: :cascade do |t|
    t.text     "enunciado",   null: false
    t.integer  "tipo",        null: false, default: 0
    t.integer  "template_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "opcao_questoes", force: :cascade do |t|
    t.string   "texto",              null: false
    t.integer  "questao_template_id", null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "formularios", force: :cascade do |t|
    t.string   "titulo",      null: false
    t.datetime "prazo"
    t.integer  "turma_id",    null: false
    t.integer  "template_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "questoes", force: :cascade do |t|
    t.text     "enunciado",          null: false
    t.integer  "tipo",               null: false, default: 0
    t.integer  "formulario_id",      null: false
    t.integer  "questao_template_id", null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "envio_formularios", force: :cascade do |t|
    t.integer  "formulario_id", null: false
    t.integer  "discente_id",   null: false
    t.datetime "enviado_em"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["formulario_id", "discente_id"], name: "index_envio_formularios_on_formulario_id_and_discente_id", unique: true
  end

  create_table "respostas", force: :cascade do |t|
    t.text     "conteudo",             null: false
    t.integer  "envio_formulario_id",  null: false
    t.integer  "questao_id",           null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  # ── Dados importados SIGAA ──────────────────────────────────────────────────
  create_table "dado_users", force: :cascade do |t|
    t.string   "curso"
    t.string   "email"
    t.string   "formacao"
    t.string   "matricula"
    t.string   "nome"
    t.string   "ocupacao"
    t.string   "usuario"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "admins",            "departamentos",    column: "departamento_id"
  add_foreign_key "admins",            "users",            column: "user_id"
  add_foreign_key "docentes",          "usuarios",         column: "usuario_id"
  add_foreign_key "docentes",          "departamentos",    column: "departamento_id"
  add_foreign_key "discentes",         "usuarios",         column: "usuario_id"
  add_foreign_key "turmas",            "departamentos",    column: "departamento_id"
  add_foreign_key "matriculas",        "discentes",        column: "discente_id"
  add_foreign_key "matriculas",        "turmas",           column: "turma_id"
  add_foreign_key "templates",         "docentes",         column: "docente_id"
  add_foreign_key "questao_templates", "templates",        column: "template_id"
  add_foreign_key "opcao_questoes",    "questao_templates", column: "questao_template_id"
  add_foreign_key "formularios",       "turmas",           column: "turma_id"
  add_foreign_key "formularios",       "templates",        column: "template_id"
  add_foreign_key "questoes",          "formularios",      column: "formulario_id"
  add_foreign_key "questoes",          "questao_templates", column: "questao_template_id"
  add_foreign_key "envio_formularios", "formularios",      column: "formulario_id"
  add_foreign_key "envio_formularios", "discentes",        column: "discente_id"
  add_foreign_key "respostas",         "envio_formularios", column: "envio_formulario_id"
  add_foreign_key "respostas",         "questoes",         column: "questao_id"
end
