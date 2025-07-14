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

ActiveRecord::Schema[8.0].define(version: 2025_07_14_000749) do
  create_table "cursos", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "disciplinas", force: :cascade do |t|
    t.string "nome"
    t.integer "curso_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "codigo"
    t.string "codigo_turma"
    t.string "semestre"
    t.string "horario"
    t.index ["curso_id"], name: "index_disciplinas_on_curso_id"
  end

  create_table "formularios", force: :cascade do |t|
    t.integer "template_id", null: false
    t.integer "turma_id"
    t.integer "coordenador_id", null: false
    t.datetime "data_envio"
    t.datetime "data_fim"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "ativo", default: false
    t.integer "escopo_visibilidade", default: 0, null: false
    t.integer "disciplina_id"
    t.index ["coordenador_id"], name: "index_formularios_on_coordenador_id"
    t.index ["disciplina_id"], name: "index_formularios_on_disciplina_id"
    t.index ["escopo_visibilidade", "disciplina_id"], name: "index_formularios_on_escopo_visibilidade_and_disciplina_id"
    t.index ["escopo_visibilidade"], name: "index_formularios_on_escopo_visibilidade"
    t.index ["template_id"], name: "index_formularios_on_template_id"
    t.index ["turma_id"], name: "index_formularios_on_turma_id"
  end

  create_table "matriculas", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "turma_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "situacao", default: "matriculado", null: false
    t.index ["situacao"], name: "index_matriculas_on_situacao"
    t.index ["turma_id"], name: "index_matriculas_on_turma_id"
    t.index ["user_id"], name: "index_matriculas_on_user_id"
  end

  create_table "opcoes_pergunta", force: :cascade do |t|
    t.integer "pergunta_id", null: false
    t.string "texto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pergunta_id"], name: "index_opcoes_pergunta_on_pergunta_id"
  end

  create_table "pergunta", force: :cascade do |t|
    t.integer "template_id", null: false
    t.string "texto"
    t.integer "tipo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "obrigatoria", default: true
    t.index ["template_id"], name: "index_pergunta_on_template_id"
  end

  create_table "resposta", force: :cascade do |t|
    t.integer "formulario_id", null: false
    t.integer "pergunta_id", null: false
    t.integer "opcao_id"
    t.text "resposta_texto"
    t.integer "turma_id"
    t.string "uuid_anonimo", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["formulario_id"], name: "index_resposta_on_formulario_id"
    t.index ["opcao_id"], name: "index_resposta_on_opcao_id"
    t.index ["pergunta_id"], name: "index_resposta_on_pergunta_id"
    t.index ["turma_id"], name: "index_resposta_on_turma_id"
  end

  create_table "submissoes_concluidas", force: :cascade do |t|
    t.integer "user_id"
    t.integer "formulario_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid_anonimo", null: false
    t.index ["formulario_id"], name: "index_submissoes_concluidas_on_formulario_id"
    t.index ["user_id", "formulario_id"], name: "index_submissoes_concluidas_unique", unique: true
    t.index ["user_id"], name: "index_submissoes_concluidas_on_user_id"
  end

  create_table "templates", force: :cascade do |t|
    t.string "titulo"
    t.integer "publico_alvo"
    t.integer "criado_por_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "descricao"
    t.integer "disciplina_id"
    t.index ["criado_por_id"], name: "index_templates_on_criado_por_id"
    t.index ["disciplina_id"], name: "index_templates_on_disciplina_id"
  end

  create_table "turmas", force: :cascade do |t|
    t.integer "disciplina_id", null: false
    t.integer "professor_id", null: false
    t.string "semestre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["disciplina_id"], name: "index_turmas_on_disciplina_id"
    t.index ["professor_id"], name: "index_turmas_on_professor_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "matricula"
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "encrypted_password", default: "", null: false
    t.string "curso"
    t.string "departamento"
    t.string "formacao"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["matricula"], name: "index_users_on_matricula", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "disciplinas", "cursos"
  add_foreign_key "formularios", "disciplinas"
  add_foreign_key "formularios", "templates"
  add_foreign_key "formularios", "turmas"
  add_foreign_key "formularios", "users", column: "coordenador_id"
  add_foreign_key "matriculas", "turmas"
  add_foreign_key "matriculas", "users"
  add_foreign_key "opcoes_pergunta", "pergunta", column: "pergunta_id"
  add_foreign_key "pergunta", "templates"
  add_foreign_key "resposta", "formularios"
  add_foreign_key "resposta", "opcoes_pergunta", column: "opcao_id"
  add_foreign_key "resposta", "pergunta", column: "pergunta_id"
  add_foreign_key "resposta", "turmas"
  add_foreign_key "submissoes_concluidas", "formularios"
  add_foreign_key "submissoes_concluidas", "users"
  add_foreign_key "templates", "disciplinas"
  add_foreign_key "templates", "users", column: "criado_por_id"
  add_foreign_key "turmas", "disciplinas"
  add_foreign_key "turmas", "users", column: "professor_id"
end
