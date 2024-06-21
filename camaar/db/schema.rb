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

ActiveRecord::Schema[7.1].define(version: 2024_06_21_092341) do
  create_table "alternativas", force: :cascade do |t|
    t.integer "questao_id", null: false
    t.string "texto", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["questao_id"], name: "index_alternativas_on_questao_id"
  end

  create_table "dicentes", force: :cascade do |t|
    t.string "curso", null: false
    t.string "matricula", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_dicentes_on_user_id"
  end

  create_table "disciplinas", force: :cascade do |t|
    t.string "codigo", null: false
    t.string "nome", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codigo"], name: "index_disciplinas_on_codigo", unique: true
  end

  create_table "docentes", force: :cascade do |t|
    t.string "departamento", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_docentes_on_user_id"
  end

  create_table "formularios", force: :cascade do |t|
    t.date "dataDeTermino", null: false
    t.string "nome", null: false
    t.integer "docente_id", null: false
    t.integer "template_id", null: false
    t.integer "turma_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["docente_id"], name: "index_formularios_on_docente_id"
    t.index ["template_id"], name: "index_formularios_on_template_id"
    t.index ["turma_id"], name: "index_formularios_on_turma_id"
  end

  create_table "formularios_turmas", force: :cascade do |t|
    t.integer "formulario_id", null: false
    t.integer "turma_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["formulario_id"], name: "index_formularios_turmas_on_formulario_id"
    t.index ["turma_id"], name: "index_formularios_turmas_on_turma_id"
  end

  create_table "questaos", force: :cascade do |t|
    t.string "pergunta", null: false
    t.integer "tipo_id", null: false
    t.integer "template_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_questaos_on_template_id"
    t.index ["tipo_id"], name: "index_questaos_on_tipo_id"
  end

  create_table "respostas", force: :cascade do |t|
    t.integer "resultado_id", null: false
    t.integer "questao_id", null: false
    t.text "conteudo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["questao_id"], name: "index_respostas_on_questao_id"
    t.index ["resultado_id"], name: "index_respostas_on_resultado_id"
  end

  create_table "resultados", force: :cascade do |t|
    t.integer "dicente_id", null: false
    t.integer "formulario_id", null: false
    t.integer "resposta_id", null: false
    t.integer "questao_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dicente_id"], name: "index_resultados_on_dicente_id"
    t.index ["formulario_id"], name: "index_resultados_on_formulario_id"
    t.index ["questao_id"], name: "index_resultados_on_questao_id"
    t.index ["resposta_id"], name: "index_resultados_on_resposta_id"
  end

  create_table "templates", force: :cascade do |t|
    t.string "nome", null: false
    t.integer "docente_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["docente_id"], name: "index_templates_on_docente_id"
  end

  create_table "tipos", force: :cascade do |t|
    t.string "nome", null: false
    t.integer "numeroDeAlternativas", null: false
    t.boolean "discursiva?", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "turmas", force: :cascade do |t|
    t.string "class_code", null: false
    t.string "semestre", null: false
    t.string "horario", null: false
    t.string "codigo", null: false
    t.integer "disciplina_id", null: false
    t.integer "docente_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["disciplina_id"], name: "index_turmas_on_disciplina_id"
    t.index ["docente_id"], name: "index_turmas_on_docente_id"
  end

  create_table "turmas_dicentes", force: :cascade do |t|
    t.integer "turma_id", null: false
    t.integer "dicente_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dicente_id"], name: "index_turmas_dicentes_on_dicente_id"
    t.index ["turma_id"], name: "index_turmas_dicentes_on_turma_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "nome", null: false
    t.string "usuario", null: false
    t.string "formacao", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "role", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "alternativas", "questaos"
  add_foreign_key "dicentes", "users"
  add_foreign_key "docentes", "users"
  add_foreign_key "formularios", "docentes"
  add_foreign_key "formularios", "templates"
  add_foreign_key "formularios", "turmas"
  add_foreign_key "formularios_turmas", "formularios"
  add_foreign_key "formularios_turmas", "turmas"
  add_foreign_key "questaos", "templates"
  add_foreign_key "questaos", "tipos"
  add_foreign_key "respostas", "questaos"
  add_foreign_key "respostas", "resultados"
  add_foreign_key "resultados", "dicentes"
  add_foreign_key "resultados", "formularios"
  add_foreign_key "resultados", "questaos"
  add_foreign_key "resultados", "resposta", column: "resposta_id"
  add_foreign_key "templates", "docentes"
  add_foreign_key "turmas", "disciplinas"
  add_foreign_key "turmas", "docentes"
  add_foreign_key "turmas_dicentes", "dicentes"
  add_foreign_key "turmas_dicentes", "turmas"
end
