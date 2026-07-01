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

ActiveRecord::Schema[8.1].define(version: 2026_06_30_150000) do
  create_table "discentes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "curso"
    t.string "email"
    t.string "formacao"
    t.string "matricula"
    t.string "nome"
    t.string "ocupacao"
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
    t.string "usuario"
    t.index ["turma_id"], name: "index_discentes_on_turma_id"
  end

  create_table "disciplinas", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "docentes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "departamento"
    t.string "email"
    t.string "formacao"
    t.string "nome"
    t.string "ocupacao"
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
    t.string "usuario"
    t.index ["turma_id"], name: "index_docentes_on_turma_id"
  end

  create_table "form_responses", force: :cascade do |t|
    t.text "answers"
    t.datetime "created_at", null: false
    t.integer "form_id", null: false
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["form_id"], name: "index_form_responses_on_form_id"
    t.index ["turma_id"], name: "index_form_responses_on_turma_id"
    t.index ["user_id"], name: "index_form_responses_on_user_id"
  end

  create_table "forms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "destinatario", default: "discente", null: false
    t.datetime "end_date"
    t.datetime "start_date"
    t.integer "template_id", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_forms_on_template_id"
  end

  create_table "forms_turmas", id: false, force: :cascade do |t|
    t.integer "form_id", null: false
    t.integer "turma_id", null: false
    t.index ["form_id", "turma_id"], name: "index_forms_turmas_on_form_id_and_turma_id", unique: true
    t.index ["turma_id", "form_id"], name: "index_forms_turmas_on_turma_id_and_form_id"
  end

  create_table "formularios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deadline"
    t.text "descricao"
    t.string "destinatario", default: "discente", null: false
    t.string "titulo"
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
  end

  create_table "perguntas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "enunciado"
    t.integer "formulario_id", null: false
    t.boolean "obrigatoria"
    t.string "tipo_pergunta"
    t.datetime "updated_at", null: false
    t.index ["formulario_id"], name: "index_perguntas_on_formulario_id"
  end

  create_table "questions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "kind", null: false
    t.boolean "obrigatoria", default: false, null: false
    t.text "options"
    t.integer "template_id", null: false
    t.text "text", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_questions_on_template_id"
  end

  create_table "respostas", force: :cascade do |t|
    t.text "conteudo"
    t.datetime "created_at", null: false
    t.integer "formulario_id", null: false
    t.integer "pergunta_id", null: false
    t.string "status", default: "submitted", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["formulario_id"], name: "index_respostas_on_formulario_id"
    t.index ["pergunta_id"], name: "index_respostas_on_pergunta_id"
    t.index ["user_id"], name: "index_respostas_on_user_id"
  end

  create_table "sigaa_logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "message"
    t.string "status"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sigaa_logs_on_user_id"
  end

  create_table "templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "descricao"
    t.string "nome", null: false
    t.integer "parent_template_id"
    t.string "semester"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "version", default: 1, null: false
    t.index ["parent_template_id"], name: "index_templates_on_parent_template_id"
    t.index ["user_id"], name: "index_templates_on_user_id"
  end

  create_table "turma_memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["turma_id", "user_id"], name: "index_turma_memberships_on_turma_id_and_user_id", unique: true
    t.index ["turma_id"], name: "index_turma_memberships_on_turma_id"
    t.index ["user_id"], name: "index_turma_memberships_on_user_id"
  end

  create_table "turmas", force: :cascade do |t|
    t.string "classCode"
    t.datetime "created_at", null: false
    t.integer "disciplina_id", null: false
    t.string "nome"
    t.string "semester"
    t.string "time"
    t.datetime "updated_at", null: false
    t.index ["disciplina_id"], name: "index_turmas_on_disciplina_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "departamento"
    t.string "email"
    t.datetime "invitation_sent_at"
    t.string "invitation_token"
    t.string "matricula"
    t.string "nome"
    t.string "password_digest"
    t.datetime "reset_sent_at"
    t.string "reset_token"
    t.string "role"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "discentes", "turmas"
  add_foreign_key "docentes", "turmas"
  add_foreign_key "form_responses", "forms"
  add_foreign_key "form_responses", "turmas"
  add_foreign_key "form_responses", "users"
  add_foreign_key "forms", "templates"
  add_foreign_key "formularios", "turmas"
  add_foreign_key "perguntas", "formularios_old", column: "formulario_id"
  add_foreign_key "questions", "templates"
  add_foreign_key "respostas", "formularios_old", column: "formulario_id"
  add_foreign_key "respostas", "perguntas"
  add_foreign_key "respostas", "users"
  add_foreign_key "sigaa_logs", "users"
  add_foreign_key "templates", "templates", column: "parent_template_id"
  add_foreign_key "templates", "users"
  add_foreign_key "turma_memberships", "turmas"
  add_foreign_key "turma_memberships", "users"
  add_foreign_key "turmas", "disciplinas"
end
