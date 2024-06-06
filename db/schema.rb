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

ActiveRecord::Schema[7.1].define(version: 2024_06_06_161228) do
  create_table "alunos", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nome"
    t.integer "matricula"
    t.integer "materia_id", null: false
    t.index ["email"], name: "index_alunos_on_email", unique: true
    t.index ["materia_id"], name: "index_alunos_on_materia_id"
    t.index ["reset_password_token"], name: "index_alunos_on_reset_password_token", unique: true
  end

  create_table "departamentos", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "formulario_templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nome"
    t.integer "formularios_id", null: false
    t.index ["formularios_id"], name: "index_formulario_templates_on_formularios_id"
  end

  create_table "formularios", force: :cascade do |t|
    t.text "perguntas"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nome"
    t.integer "formulario_templates_id", null: false
    t.index ["formulario_templates_id"], name: "index_formularios_on_formulario_templates_id"
  end

  create_table "materia", force: :cascade do |t|
    t.integer "codigo"
    t.integer "semestre"
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "departamento_id", null: false
    t.integer "professors_id", null: false
    t.integer "alunos_id", null: false
    t.datetime "horario"
    t.index ["alunos_id"], name: "index_materia_on_alunos_id"
    t.index ["departamento_id"], name: "index_materia_on_departamento_id"
    t.index ["professors_id"], name: "index_materia_on_professors_id"
  end

  create_table "professors", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_admin"
    t.string "nome"
    t.integer "departamento_id", null: false
    t.integer "materia_id", null: false
    t.index ["departamento_id"], name: "index_professors_on_departamento_id"
    t.index ["email"], name: "index_professors_on_email", unique: true
    t.index ["materia_id"], name: "index_professors_on_materia_id"
    t.index ["reset_password_token"], name: "index_professors_on_reset_password_token", unique: true
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

  add_foreign_key "alunos", "materia", column: "materia_id"
  add_foreign_key "formulario_templates", "formularios", column: "formularios_id"
  add_foreign_key "formularios", "formulario_templates", column: "formulario_templates_id"
  add_foreign_key "materia", "alunos", column: "alunos_id"
  add_foreign_key "materia", "departamentos"
  add_foreign_key "materia", "professors", column: "professors_id"
  add_foreign_key "professors", "departamentos"
  add_foreign_key "professors", "materia", column: "materia_id"
  add_foreign_key "reports_alunos", "formularios", column: "formularios_id"
  add_foreign_key "reports_professors", "formularios", column: "formularios_id"
end
