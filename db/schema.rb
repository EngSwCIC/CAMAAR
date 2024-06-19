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

ActiveRecord::Schema[7.1].define(version: 2024_06_19_192715) do
  create_table "answers", force: :cascade do |t|
    t.string "answer", null: false
    t.integer "user_id", null: false
    t.integer "question_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "disciplines", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "professor_registration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "semester_id"
  end

  create_table "forms", force: :cascade do |t|
    t.integer "template_id"
    t.integer "questions_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["questions_id"], name: "index_forms_on_questions_id"
    t.index ["template_id"], name: "index_forms_on_template_id"
  end

  create_table "professors", force: :cascade do |t|
    t.string "registration_number", null: false
    t.string "name", null: false
    t.string "department_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registration_number"], name: "index_professors_on_registration_number", unique: true
  end

  create_table "questions", force: :cascade do |t|
    t.string "type"
    t.string "description"
    t.string "label", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "input"
    t.string "format"
    t.string "formlike_type", null: false
    t.integer "formlike_id", null: false
    t.index ["formlike_type", "formlike_id"], name: "index_questions_on_formlike"
  end

  create_table "semesters", force: :cascade do |t|
    t.boolean "half", null: false
    t.integer "year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "templates_id"
    t.integer "forms_id"
    t.index ["forms_id"], name: "index_semesters_on_forms_id"
    t.index ["templates_id"], name: "index_semesters_on_templates_id"
  end

  create_table "sign_up_availables", force: :cascade do |t|
    t.string "email", null: false
    t.string "key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "registration_number"
    t.index ["email"], name: "index_sign_up_availables_on_email", unique: true
  end

  create_table "templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "created_at", null: false
    t.string "salt", null: false
    t.string "password", null: false
    t.string "session_key"
    t.boolean "is_admin", default: false
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users"
  add_foreign_key "forms", "questions", column: "questions_id"
  add_foreign_key "forms", "templates"
  add_foreign_key "semesters", "forms", column: "forms_id"
  add_foreign_key "semesters", "templates", column: "templates_id"
end
