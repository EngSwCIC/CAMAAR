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

ActiveRecord::Schema[7.1].define(version: 2024_06_21_052602) do
  create_table "formularios", force: :cascade do |t|
    t.integer "id_turma"
    t.integer "id_template"
    t.integer "turma_id"
    t.integer "template_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "respostas_id"
    t.index ["respostas_id"], name: "index_formularios_on_respostas_id"
    t.index ["template_id"], name: "index_formularios_on_template_id"
    t.index ["turma_id"], name: "index_formularios_on_turma_id"
  end

  create_table "materias", force: :cascade do |t|
    t.string "code"
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questoes", force: :cascade do |t|
    t.string "tipo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "respostas_id"
    t.index ["respostas_id"], name: "index_questoes_on_respostas_id"
  end

  create_table "questoes_templates", force: :cascade do |t|
    t.integer "questao_id", null: false
    t.integer "template_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["questao_id"], name: "index_questoes_templates_on_questao_id"
    t.index ["template_id"], name: "index_questoes_templates_on_template_id"
  end

  create_table "respostas", force: :cascade do |t|
    t.text "resposta"
    t.integer "numero"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "templates", force: :cascade do |t|
    t.string "nome"
    t.string "semestre"
    t.integer "usuario"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_templates_on_users_id"
  end

  create_table "turmas", force: :cascade do |t|
    t.string "classCode"
    t.string "semestre"
    t.integer "id_professor", null: false
    t.integer "materia_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "horario"
    t.string "nome"
    t.index ["materia_id"], name: "index_turmas_on_materia_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nome", default: "", null: false
    t.string "curso", default: "", null: false
    t.string "ocupacao", default: "", null: false
    t.string "formacao", default: "", null: false
    t.string "matricula", default: "", null: false
    t.string "usuario", default: "", null: false
    t.boolean "isAdmin", default: false
    t.integer "respostas_id"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "departamento", default: "", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["respostas_id"], name: "index_users_on_respostas_id"
    t.index ["usuario"], name: "index_users_on_usuario", unique: true
  end

  create_table "users_turmas", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "turma_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["turma_id"], name: "index_users_turmas_on_turma_id"
    t.index ["user_id", "turma_id"], name: "index_users_turmas_on_user_id_and_turma_id", unique: true
    t.index ["user_id"], name: "index_users_turmas_on_user_id"
  end

  add_foreign_key "formularios", "respostas", column: "respostas_id"
  add_foreign_key "formularios", "templates"
  add_foreign_key "formularios", "turmas"
  add_foreign_key "questoes", "respostas", column: "respostas_id"
  add_foreign_key "questoes_templates", "questoes"
  add_foreign_key "questoes_templates", "templates"
  add_foreign_key "templates", "users"
  add_foreign_key "turmas", "materias"
  add_foreign_key "users", "respostas", column: "respostas_id"
  add_foreign_key "users_turmas", "turmas"
  add_foreign_key "users_turmas", "users"
end
