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

ActiveRecord::Schema[7.1].define(version: 2024_06_20_143837) do
  create_table "study_classes", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "classCode"
    t.string "semester"
    t.string "time"
    t.integer "docente_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["docente_id"], name: "index_study_classes_on_docente_id"
  end

  create_table "study_classes_users", id: false, force: :cascade do |t|
    t.integer "study_class_id", null: false
    t.integer "user_id", null: false
    t.index ["study_class_id"], name: "index_study_classes_users_on_study_class_id"
    t.index ["user_id"], name: "index_study_classes_users_on_user_id"
  end

  create_table "template_questions", force: :cascade do |t|
    t.string "title"
    t.string "type"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "template_id", null: false
    t.index ["template_id"], name: "index_template_questions_on_template_id"
  end

  create_table "templates", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "matricula", default: "", null: false
    t.string "nome"
    t.string "usuario"
    t.string "formacao"
    t.string "ocupacao"
    t.string "curso"
    t.string "departamento"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["matricula"], name: "index_users_on_matricula", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "study_classes", "users", column: "docente_id"
  add_foreign_key "template_questions", "templates"
end
