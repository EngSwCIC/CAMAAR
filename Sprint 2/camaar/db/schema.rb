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

ActiveRecord::Schema[7.1].define(version: 2026_06_15_100001) do
  create_table "avaliacaos", force: :cascade do |t|
    t.datetime "data_inicio"
    t.datetime "data_fim"
    t.integer "template_id", null: false
    t.integer "turma_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tipo", default: "discente", null: false
    t.index ["template_id"], name: "index_avaliacaos_on_template_id"
    t.index ["turma_id"], name: "index_avaliacaos_on_turma_id"
  end

  create_table "disciplinas", force: :cascade do |t|
    t.string "codigo"
    t.string "nome"
    t.string "department"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codigo"], name: "index_disciplinas_on_codigo", unique: true
  end

  create_table "questaos", force: :cascade do |t|
    t.string "enunciado"
    t.integer "template_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_questaos_on_template_id"
  end

  create_table "respostas", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "avaliacao_id", null: false
    t.integer "questao_id", null: false
    t.string "texto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["avaliacao_id"], name: "index_respostas_on_avaliacao_id"
    t.index ["questao_id"], name: "index_respostas_on_questao_id"
    t.index ["user_id", "avaliacao_id", "questao_id"], name: "index_respostas_on_user_id_and_avaliacao_id_and_questao_id", unique: true
    t.index ["user_id"], name: "index_respostas_on_user_id"
  end

  create_table "templates", force: :cascade do |t|
    t.string "titulo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "turma_alunos", force: :cascade do |t|
    t.integer "turma_id", null: false
    t.integer "aluno_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["turma_id", "aluno_id"], name: "index_turma_alunos_on_turma_id_and_aluno_id", unique: true
    t.index ["turma_id"], name: "index_turma_alunos_on_turma_id"
  end

  create_table "turmas", force: :cascade do |t|
    t.integer "disciplina_id", null: false
    t.string "codigo"
    t.string "semestre"
    t.string "horario"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["disciplina_id"], name: "index_turmas_on_disciplina_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "role"
    t.string "department"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "matricula"
    t.boolean "first_access", default: true, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["matricula"], name: "index_users_on_matricula", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "avaliacaos", "templates"
  add_foreign_key "avaliacaos", "turmas"
  add_foreign_key "questaos", "templates"
  add_foreign_key "respostas", "avaliacaos"
  add_foreign_key "respostas", "questaos"
  add_foreign_key "respostas", "users"
  add_foreign_key "turma_alunos", "turmas"
  add_foreign_key "turmas", "disciplinas"
end
