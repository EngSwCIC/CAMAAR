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

ActiveRecord::Schema[8.1].define(version: 2026_06_16_163715) do
  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "departamento_id", null: false
    t.datetime "updated_at", null: false
    t.integer "usuario_id", null: false
    t.index ["departamento_id"], name: "index_admins_on_departamento_id"
    t.index ["usuario_id"], name: "index_admins_on_usuario_id"
  end

  create_table "criador_formularios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "usuario_id", null: false
    t.index ["usuario_id"], name: "index_criador_formularios_on_usuario_id"
  end

  create_table "departamentos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nome_departamento"
    t.datetime "updated_at", null: false
  end

  create_table "departments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_departments_on_name", unique: true
  end

  create_table "enrollments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["turma_id"], name: "index_enrollments_on_turma_id"
    t.index ["user_id", "turma_id"], name: "index_enrollments_on_user_id_and_turma_id", unique: true
    t.index ["user_id"], name: "index_enrollments_on_user_id"
  end

  create_table "estudantes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "matricula"
    t.datetime "updated_at", null: false
    t.integer "usuario_id", null: false
    t.index ["usuario_id"], name: "index_estudantes_on_usuario_id"
  end

  create_table "formularios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "criador_formulario_id", null: false
    t.string "nome_formulario"
    t.float "nota_final"
    t.float "nota_media"
    t.boolean "publico_estudante"
    t.integer "template_formulario_id", null: false
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
    t.index ["criador_formulario_id"], name: "index_formularios_on_criador_formulario_id"
    t.index ["template_formulario_id"], name: "index_formularios_on_template_formulario_id"
    t.index ["turma_id"], name: "index_formularios_on_turma_id"
  end

  create_table "materia", force: :cascade do |t|
    t.string "codigoMateria"
    t.datetime "created_at", null: false
    t.integer "departamento_id", null: false
    t.string "descricao_materia"
    t.string "nome_materia"
    t.datetime "updated_at", null: false
    t.index ["departamento_id"], name: "index_materia_on_departamento_id"
  end

  create_table "matriculas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "estudante_id", null: false
    t.boolean "trancado"
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
    t.index ["estudante_id"], name: "index_matriculas_on_estudante_id"
    t.index ["turma_id"], name: "index_matriculas_on_turma_id"
  end

  create_table "pergunta", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "enunciado"
    t.string "gabarito_discursiva"
    t.integer "gabarito_radio"
    t.integer "numero_opcoes"
    t.json "opcoes_radio"
    t.integer "template_formulario_id", null: false
    t.integer "tipo_pergunta"
    t.datetime "updated_at", null: false
    t.index ["template_formulario_id"], name: "index_pergunta_on_template_formulario_id"
  end

  create_table "pergunta_formularios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "enunciado"
    t.integer "formulario_id", null: false
    t.text "gabarito_discursiva"
    t.integer "gabarito_radio"
    t.integer "numero_opcoes"
    t.json "opcoes_radio"
    t.integer "pergunta_id"
    t.integer "tipo_pergunta"
    t.datetime "updated_at", null: false
    t.index ["formulario_id"], name: "index_pergunta_formularios_on_formulario_id"
    t.index ["pergunta_id"], name: "index_pergunta_formularios_on_pergunta_id"
  end

  create_table "professors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "usuario_id", null: false
    t.index ["usuario_id"], name: "index_professors_on_usuario_id"
  end

  create_table "questoes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "enunciado", null: false
    t.integer "formulario_id", null: false
    t.integer "position", default: 0, null: false
    t.boolean "required", default: true, null: false
    t.datetime "updated_at", null: false
    t.index ["formulario_id"], name: "index_questoes_on_formulario_id"
  end

  create_table "resposta_formularios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "data_resposta"
    t.integer "formulario_id", null: false
    t.datetime "updated_at", null: false
    t.integer "usuario_id", null: false
    t.index ["formulario_id"], name: "index_resposta_formularios_on_formulario_id"
    t.index ["usuario_id"], name: "index_resposta_formularios_on_usuario_id"
  end

  create_table "resposta_pergunta", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "dataResposta"
    t.integer "formulario_id", null: false
    t.datetime "updated_at", null: false
    t.integer "usuario_id", null: false
    t.index ["formulario_id"], name: "index_resposta_pergunta_on_formulario_id"
    t.index ["usuario_id"], name: "index_resposta_pergunta_on_usuario_id"
  end

  create_table "resposta_questoes", force: :cascade do |t|
    t.text "answer"
    t.datetime "created_at", null: false
    t.integer "questao_id", null: false
    t.integer "resposta_id", null: false
    t.datetime "updated_at", null: false
    t.index ["questao_id"], name: "index_resposta_questoes_on_questao_id"
    t.index ["resposta_id", "questao_id"], name: "index_resposta_questoes_on_resposta_id_and_questao_id", unique: true
    t.index ["resposta_id"], name: "index_resposta_questoes_on_resposta_id"
  end

  create_table "respostas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "formulario_id", null: false
    t.datetime "submitted_at", null: false
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["formulario_id"], name: "index_respostas_on_formulario_id"
    t.index ["turma_id"], name: "index_respostas_on_turma_id"
    t.index ["user_id", "formulario_id", "turma_id"], name: "index_respostas_on_user_id_and_formulario_id_and_turma_id", unique: true
    t.index ["user_id"], name: "index_respostas_on_user_id"
  end

  create_table "template_formularios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "criador_formulario_id", null: false
    t.string "nome_template"
    t.datetime "updated_at", null: false
    t.index ["criador_formulario_id"], name: "index_template_formularios_on_criador_formulario_id"
  end

  create_table "templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_templates_on_name", unique: true
  end

  create_table "turma_formularios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "formulario_id", null: false
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
    t.index ["formulario_id"], name: "index_turma_formularios_on_formulario_id"
    t.index ["turma_id", "formulario_id"], name: "index_turma_formularios_on_turma_id_and_formulario_id", unique: true
    t.index ["turma_id"], name: "index_turma_formularios_on_turma_id"
  end

  create_table "turmas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "materia_id", null: false
    t.float "nota_turma"
    t.integer "numero_turma"
    t.integer "professor_id", null: false
    t.string "semestre_string"
    t.datetime "updated_at", null: false
    t.index ["materia_id"], name: "index_turmas_on_materia_id"
    t.index ["professor_id"], name: "index_turmas_on_professor_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "department_id"
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "usuarios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "matricula"
    t.string "nome"
    t.string "password_digest"
    t.datetime "password_reset_sent_at"
    t.string "password_reset_token"
    t.integer "role"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "admins", "departamentos"
  add_foreign_key "admins", "usuarios"
  add_foreign_key "criador_formularios", "usuarios"
  add_foreign_key "enrollments", "turmas"
  add_foreign_key "enrollments", "users"
  add_foreign_key "estudantes", "usuarios"
  add_foreign_key "formularios", "criador_formularios"
  add_foreign_key "formularios", "template_formularios"
  add_foreign_key "formularios", "turmas"
  add_foreign_key "materia", "departamentos"
  add_foreign_key "matriculas", "estudantes"
  add_foreign_key "matriculas", "turmas"
  add_foreign_key "pergunta", "template_formularios"
  add_foreign_key "pergunta_formularios", "formularios"
  add_foreign_key "pergunta_formularios", "pergunta", column: "pergunta_id", on_delete: :nullify
  add_foreign_key "professors", "usuarios"
  add_foreign_key "questoes", "formularios"
  add_foreign_key "resposta_formularios", "formularios"
  add_foreign_key "resposta_formularios", "usuarios"
  add_foreign_key "resposta_pergunta", "formularios"
  add_foreign_key "resposta_pergunta", "usuarios"
  add_foreign_key "resposta_questoes", "questoes"
  add_foreign_key "resposta_questoes", "respostas"
  add_foreign_key "respostas", "formularios"
  add_foreign_key "respostas", "turmas"
  add_foreign_key "respostas", "users"
  add_foreign_key "template_formularios", "criador_formularios"
  add_foreign_key "turma_formularios", "formularios"
  add_foreign_key "turma_formularios", "turmas"
  add_foreign_key "turmas", "materia", column: "materia_id"
  add_foreign_key "turmas", "professors"
  add_foreign_key "users", "departments"
end
