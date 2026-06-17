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

ActiveRecord::Schema[8.1].define(version: 2026_06_15_220605) do
  create_table "campo_forms", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "elemento_form_id", null: false
    t.string "enunciado"
    t.integer "ordem"
    t.datetime "updated_at", null: false
    t.index ["elemento_form_id"], name: "index_campo_forms_on_elemento_form_id"
  end

  create_table "campos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "elemento_id", null: false
    t.string "enunciado"
    t.integer "ordem"
    t.string "tipo_elemento"
    t.datetime "updated_at", null: false
    t.index ["elemento_id"], name: "index_campos_on_elemento_id"
  end

  create_table "cursos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "codigo"
    t.datetime "created_at", null: false
    t.bigint "departamento_id", null: false
    t.string "nome"
    t.datetime "updated_at", null: false
    t.index ["codigo"], name: "index_cursos_on_codigo", unique: true
    t.index ["departamento_id"], name: "index_cursos_on_departamento_id"
  end

  create_table "departamentos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "codigo"
    t.datetime "created_at", null: false
    t.string "nome"
    t.datetime "updated_at", null: false
    t.index ["codigo"], name: "index_departamentos_on_codigo", unique: true
  end

  create_table "discentes_turmas", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "discente_id", null: false
    t.bigint "turma_id", null: false
  end

  create_table "disciplinas", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "codigo"
    t.datetime "created_at", null: false
    t.bigint "departamento_id", null: false
    t.string "nome"
    t.datetime "updated_at", null: false
    t.index ["codigo"], name: "index_disciplinas_on_codigo", unique: true
    t.index ["departamento_id"], name: "index_disciplinas_on_departamento_id"
  end

  create_table "docentes_turmas", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "docente_id", null: false
    t.bigint "turma_id", null: false
  end

  create_table "elemento_forms", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "enunciado"
    t.bigint "formulario_id", null: false
    t.integer "ordem"
    t.datetime "updated_at", null: false
    t.index ["formulario_id"], name: "index_elemento_forms_on_formulario_id"
  end

  create_table "elementos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "enunciado"
    t.integer "ordem"
    t.bigint "template_id", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_elementos_on_template_id"
  end

  create_table "formularios", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "turma_id", null: false
    t.datetime "updated_at", null: false
    t.index ["turma_id"], name: "index_formularios_on_turma_id"
  end

  create_table "resposta_elems", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "campo_form_id"
    t.datetime "created_at", null: false
    t.bigint "elemento_form_id", null: false
    t.bigint "resposta_form_id", null: false
    t.text "texto_resposta"
    t.datetime "updated_at", null: false
    t.index ["campo_form_id"], name: "index_resposta_elems_on_campo_form_id"
    t.index ["elemento_form_id"], name: "index_resposta_elems_on_elemento_form_id"
    t.index ["resposta_form_id"], name: "index_resposta_elems_on_resposta_form_id"
  end

  create_table "resposta_forms", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "data_submissao"
    t.bigint "formulario_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "usuario_id", null: false
    t.index ["formulario_id"], name: "index_resposta_forms_on_formulario_id"
    t.index ["usuario_id"], name: "index_resposta_forms_on_usuario_id"
  end

  create_table "templates", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nome"
    t.datetime "updated_at", null: false
    t.bigint "usuario_id", null: false
    t.index ["usuario_id"], name: "index_templates_on_usuario_id"
  end

  create_table "turmas", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "disciplina_id", null: false
    t.string "horario"
    t.string "numero_da_turma"
    t.string "semestre"
    t.datetime "updated_at", null: false
    t.index ["disciplina_id"], name: "index_turmas_on_disciplina_id"
  end

  create_table "usuarios", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "curso_id"
    t.datetime "definicao_senha_sent_at"
    t.string "definicao_senha_token"
    t.bigint "departamento_id"
    t.string "email"
    t.string "formacao"
    t.string "matricula"
    t.string "nome"
    t.datetime "redefinicao_senha_sent_at"
    t.string "redefinicao_senha_token"
    t.string "senha_hash"
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["curso_id"], name: "index_usuarios_on_curso_id"
    t.index ["definicao_senha_token"], name: "index_usuarios_on_definicao_senha_token", unique: true
    t.index ["departamento_id"], name: "index_usuarios_on_departamento_id"
    t.index ["matricula"], name: "index_usuarios_on_matricula", unique: true
    t.index ["redefinicao_senha_token"], name: "index_usuarios_on_redefinicao_senha_token", unique: true
  end

  create_table "workspace_states", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.json "data", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "campo_forms", "elemento_forms"
  add_foreign_key "campos", "elementos"
  add_foreign_key "cursos", "departamentos"
  add_foreign_key "disciplinas", "departamentos"
  add_foreign_key "elemento_forms", "formularios"
  add_foreign_key "elementos", "templates"
  add_foreign_key "formularios", "turmas"
  add_foreign_key "resposta_elems", "campo_forms"
  add_foreign_key "resposta_elems", "elemento_forms"
  add_foreign_key "resposta_elems", "resposta_forms"
  add_foreign_key "resposta_forms", "formularios"
  add_foreign_key "resposta_forms", "usuarios"
  add_foreign_key "templates", "usuarios"
  add_foreign_key "turmas", "disciplinas"
  add_foreign_key "usuarios", "cursos"
  add_foreign_key "usuarios", "departamentos"
end
