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

ActiveRecord::Schema[7.1].define(version: 2024_06_13_124907) do
  create_table "alunos", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nome", null: false
    t.integer "matricula", null: false
    t.string "curso", null: false
    t.index ["email"], name: "index_alunos_on_email", unique: true
    t.index ["matricula"], name: "index_alunos_on_matricula", unique: true
    t.index ["reset_password_token"], name: "index_alunos_on_reset_password_token", unique: true
  end

  create_table "alunos_materias", id: false, force: :cascade do |t|
    t.integer "aluno_id", null: false
    t.integer "materia_id", null: false
    t.index ["aluno_id", "materia_id"], name: "index_alunos_materias_on_aluno_id_and_materia_id", unique: true
    t.index ["aluno_id"], name: "index_alunos_materias_on_aluno_id"
    t.index ["materia_id", "aluno_id"], name: "index_alunos_materias_on_materia_id_and_aluno_id", unique: true
    t.index ["materia_id"], name: "index_alunos_materias_on_materia_id"
  end

  create_table "departamentos", force: :cascade do |t|
    t.string "nome", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_departamentos_on_nome", unique: true
  end

  create_table "formulario_templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nome"
    t.string "name"
  end

  create_table "formularios", force: :cascade do |t|
    t.text "perguntas"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nome"
    t.integer "formulario_templates_id", null: false
    t.string "question_type"
    t.json "options"
    t.index ["formulario_templates_id"], name: "index_formularios_on_formulario_templates_id"
  end

  create_table "materia", force: :cascade do |t|
    t.integer "codigo", null: false
    t.integer "semestre"
    t.string "nome", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "departamento_id", null: false
    t.datetime "horario"
    t.index ["departamento_id"], name: "index_materia_on_departamento_id"
  end

  create_table "materias_professors", id: false, force: :cascade do |t|
    t.integer "materia_id", null: false
    t.integer "professor_id", null: false
    t.index ["materia_id", "professor_id"], name: "index_materias_professors_on_materia_id_and_professor_id", unique: true
    t.index ["materia_id"], name: "index_materias_professors_on_materia_id"
    t.index ["professor_id", "materia_id"], name: "index_materias_professors_on_professor_id_and_materia_id", unique: true
    t.index ["professor_id"], name: "index_materias_professors_on_professor_id"
  end

  create_table "professors", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "isadmin", null: false
    t.string "nome", null: false
    t.integer "departamento_id", null: false
    t.index ["departamento_id"], name: "index_professors_on_departamento_id"
    t.index ["email"], name: "index_professors_on_email", unique: true
    t.index ["reset_password_token"], name: "index_professors_on_reset_password_token", unique: true
  end

  create_table "questions", force: :cascade do |t|
    t.integer "template_id", null: false
    t.string "question_type"
    t.text "options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_questions_on_template_id"
  end

  create_table "reports_alunos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "formularios_id", null: false
    t.index ["formularios_id"], name: "index_reports_alunos_on_formularios_id"
  end

  create_table "reports_professors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "formularios_id", null: false
    t.index ["formularios_id"], name: "index_reports_professors_on_formularios_id"
  end

  create_table "templates", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "alunos_materias", "alunos"
  add_foreign_key "alunos_materias", "materia", column: "materia_id"
  add_foreign_key "formularios", "formulario_templates", column: "formulario_templates_id"
  add_foreign_key "materia", "departamentos"
  add_foreign_key "materias_professors", "materia", column: "materia_id"
  add_foreign_key "materias_professors", "professors"
  add_foreign_key "professors", "departamentos"
  add_foreign_key "questions", "templates"
  add_foreign_key "reports_alunos", "formularios", column: "formularios_id"
  add_foreign_key "reports_professors", "formularios", column: "formularios_id"
end
