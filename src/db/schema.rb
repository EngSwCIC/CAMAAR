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

ActiveRecord::Schema[7.1].define(version: 2024_06_13_094543) do
  create_table "formularios", force: :cascade do |t|
    t.integer "id_turma"
    t.integer "id_template"
    t.integer "turma_id"
    t.integer "template_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
  end

  create_table "questoes_templates", id: false, force: :cascade do |t|
    t.integer "questao_id"
    t.integer "template_id"
    t.index ["questao_id"], name: "index_questoes_templates_on_questao_id"
    t.index ["template_id"], name: "index_questoes_templates_on_template_id"
  end

  create_table "respostas", force: :cascade do |t|
    t.text "resposta"
    t.integer "numero"
    t.integer "questao_id"
    t.integer "formulario_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["formulario_id"], name: "index_respostas_on_formulario_id"
    t.index ["questao_id"], name: "index_respostas_on_questao_id"
    t.index ["user_id"], name: "index_respostas_on_user_id"
  end

  create_table "templates", force: :cascade do |t|
    t.string "codigo"
    t.string "nome"
    t.string "semestre"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_templates_on_user_id"
  end

  create_table "templates_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "template_id"
    t.index ["template_id"], name: "index_templates_users_on_template_id"
    t.index ["user_id"], name: "index_templates_users_on_user_id"
  end

  create_table "turmas", force: :cascade do |t|
    t.string "classCode"
    t.string "semestre"
    t.integer "professor_id"
    t.integer "materia_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["materia_id"], name: "index_turmas_on_materia_id"
  end

  create_table "turmas_users", id: false, force: :cascade do |t|
    t.integer "turma_id"
    t.integer "user_id"
    t.index ["turma_id"], name: "index_turmas_users_on_turma_id"
    t.index ["user_id"], name: "index_turmas_users_on_user_id"
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "formularios", "templates"
  add_foreign_key "formularios", "turmas"
  add_foreign_key "respostas", "formularios"
  add_foreign_key "respostas", "questoes"
  add_foreign_key "respostas", "users"
  add_foreign_key "turmas", "materias"
end
