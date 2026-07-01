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

ActiveRecord::Schema[8.1].define(version: 2026_06_16_000002) do
  create_table "class_memberships", force: :cascade do |t|
    t.integer "course_class_id", null: false
    t.datetime "created_at", null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["course_class_id"], name: "index_class_memberships_on_course_class_id"
    t.index ["user_id", "course_class_id", "role"], name: "idx_on_user_id_course_class_id_role_c0460d53c1", unique: true
    t.index ["user_id"], name: "index_class_memberships_on_user_id"
  end

  create_table "course_classes", force: :cascade do |t|
    t.string "class_code", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.integer "department_id", null: false
    t.string "name"
    t.string "semester", null: false
    t.string "time"
    t.datetime "updated_at", null: false
    t.index ["code", "class_code", "semester"], name: "index_course_classes_on_code_and_class_code_and_semester", unique: true
    t.index ["department_id"], name: "index_course_classes_on_department_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_departments_on_code", unique: true
  end

  create_table "formularios", force: :cascade do |t|
    t.integer "admin_id", null: false
    t.integer "course_class_id", null: false
    t.datetime "created_at", null: false
    t.string "status"
    t.string "target_role"
    t.integer "template_id"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_formularios_on_admin_id"
    t.index ["course_class_id"], name: "index_formularios_on_course_class_id"
    t.index ["template_id"], name: "index_formularios_on_template_id"
  end

  create_table "import_inconsistencies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "message", null: false
    t.json "payload"
    t.string "source", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questaos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "enunciado"
    t.integer "formulario_id"
    t.integer "template_id"
    t.string "tipo"
    t.datetime "updated_at", null: false
    t.index ["formulario_id"], name: "index_questaos_on_formulario_id"
    t.index ["template_id"], name: "index_questaos_on_template_id"
  end

  create_table "resposta", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "questao_id", null: false
    t.integer "submissao_id", null: false
    t.datetime "updated_at", null: false
    t.integer "valor_numerico"
    t.text "valor_texto"
    t.index ["questao_id"], name: "index_resposta_on_questao_id"
    t.index ["submissao_id"], name: "index_resposta_on_submissao_id"
  end

  create_table "submissaos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "formulario_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["formulario_id"], name: "index_submissaos_on_formulario_id"
    t.index ["user_id"], name: "index_submissaos_on_user_id"
  end

  create_table "templates", force: :cascade do |t|
    t.integer "admin_id", null: false
    t.datetime "created_at", null: false
    t.string "target_role"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_templates_on_admin_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "department_id"
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest"
    t.datetime "password_reset_sent_at"
    t.string "password_reset_token_digest"
    t.datetime "password_setup_sent_at"
    t.string "password_setup_token_digest"
    t.string "registration", null: false
    t.integer "role", default: 1, null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["password_reset_token_digest"], name: "index_users_on_password_reset_token_digest", unique: true
    t.index ["password_setup_token_digest"], name: "index_users_on_password_setup_token_digest", unique: true
    t.index ["registration"], name: "index_users_on_registration", unique: true
  end

  add_foreign_key "class_memberships", "course_classes"
  add_foreign_key "class_memberships", "users"
  add_foreign_key "course_classes", "departments"
  add_foreign_key "formularios", "course_classes"
  add_foreign_key "formularios", "templates"
  add_foreign_key "formularios", "users", column: "admin_id"
  add_foreign_key "questaos", "formularios"
  add_foreign_key "questaos", "templates"
  add_foreign_key "resposta", "questaos"
  add_foreign_key "resposta", "submissaos"
  add_foreign_key "submissaos", "formularios"
  add_foreign_key "submissaos", "users"
  add_foreign_key "templates", "users", column: "admin_id"
  add_foreign_key "users", "departments"
end
