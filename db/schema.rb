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

ActiveRecord::Schema[8.1].define(version: 2026_06_16_140643) do
  create_table "enrollments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "role", default: "discente", null: false
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["turma_id"], name: "index_enrollments_on_turma_id"
    t.index ["user_id", "turma_id"], name: "index_enrollments_on_user_id_and_turma_id", unique: true
    t.index ["user_id"], name: "index_enrollments_on_user_id"
  end

  create_table "formularios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "prazo"
    t.integer "template_id", null: false
    t.string "titulo", null: false
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_formularios_on_template_id"
    t.index ["turma_id"], name: "index_formularios_on_turma_id"
  end

  create_table "questions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "enunciado", null: false
    t.text "opcoes"
    t.integer "template_id", null: false
    t.string "tipo", default: "discursiva", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_questions_on_template_id"
  end

  create_table "respostas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "formulario_id", null: false
    t.integer "question_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.text "valor"
    t.index ["formulario_id", "user_id", "question_id"], name: "index_respostas_unicas", unique: true
    t.index ["formulario_id"], name: "index_respostas_on_formulario_id"
    t.index ["question_id"], name: "index_respostas_on_question_id"
    t.index ["user_id"], name: "index_respostas_on_user_id"
  end

  create_table "templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "descricao"
    t.string "nome", null: false
    t.string "publico_alvo"
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_templates_on_nome"
  end

  create_table "turmas", force: :cascade do |t|
    t.string "class_code", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.string "departamento"
    t.string "name", null: false
    t.string "semester", null: false
    t.string "time"
    t.datetime "updated_at", null: false
    t.index ["code", "class_code", "semester"], name: "index_turmas_on_code_class_semester", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "departamento"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "invitation_accepted_at"
    t.datetime "invitation_created_at"
    t.integer "invitation_limit"
    t.datetime "invitation_sent_at"
    t.string "invitation_token"
    t.integer "invitations_count", default: 0
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.string "matricula"
    t.string "nome"
    t.string "perfil"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "enrollments", "turmas"
  add_foreign_key "enrollments", "users"
  add_foreign_key "formularios", "templates"
  add_foreign_key "formularios", "turmas"
  add_foreign_key "questions", "templates"
  add_foreign_key "respostas", "formularios"
  add_foreign_key "respostas", "questions"
  add_foreign_key "respostas", "users"
end
