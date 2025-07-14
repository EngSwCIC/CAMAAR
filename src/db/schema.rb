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

ActiveRecord::Schema[8.0].define(version: 2025_07_11_152213) do
  create_table "answered_forms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "form_id"
    t.index ["form_id"], name: "index_answered_forms_on_form_id"
    t.index ["user_id"], name: "index_answered_forms_on_user_id"
  end

  create_table "answers", force: :cascade do |t|
    t.text "justification"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "question_id"
    t.integer "option_id"
    t.index ["option_id"], name: "index_answers_on_option_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "class_forms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "class_group_id"
    t.integer "form_id"
    t.index ["class_group_id"], name: "index_class_forms_on_class_group_id"
    t.index ["form_id"], name: "index_class_forms_on_form_id"
  end

  create_table "class_groups", force: :cascade do |t|
    t.integer "subject_id", null: false
    t.integer "number"
    t.string "semester"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_class_groups_on_subject_id"
  end

  create_table "class_professors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "professor_id"
    t.integer "class_group_id"
    t.index ["class_group_id"], name: "index_class_professors_on_class_group_id"
    t.index ["professor_id"], name: "index_class_professors_on_professor_id"
  end

  create_table "class_students", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "student_id"
    t.integer "class_group_id"
    t.index ["class_group_id"], name: "index_class_students_on_class_group_id"
    t.index ["student_id"], name: "index_class_students_on_student_id"
  end

  create_table "forms", force: :cascade do |t|
    t.date "open_date"
    t.date "close_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "publisher_id"
    t.integer "template_id"
    t.index ["publisher_id"], name: "index_forms_on_publisher_id"
    t.index ["template_id"], name: "index_forms_on_template_id"
  end

  create_table "options", force: :cascade do |t|
    t.string "description"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "question_id"
    t.index ["question_id"], name: "index_options_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "template_id"
    t.index ["template_id"], name: "index_questions_on_template_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "templates", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.index ["creator_id"], name: "index_templates_on_creator_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "registration"
    t.string "email"
    t.string "role"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "answered_forms", "forms"
  add_foreign_key "answered_forms", "users"
  add_foreign_key "answers", "options"
  add_foreign_key "answers", "questions"
  add_foreign_key "class_forms", "class_groups"
  add_foreign_key "class_forms", "forms"
  add_foreign_key "class_groups", "subjects"
  add_foreign_key "class_professors", "class_groups"
  add_foreign_key "class_professors", "users", column: "professor_id"
  add_foreign_key "class_students", "class_groups"
  add_foreign_key "class_students", "users", column: "student_id"
  add_foreign_key "forms", "templates"
  add_foreign_key "forms", "users", column: "publisher_id"
  add_foreign_key "options", "questions"
  add_foreign_key "questions", "templates"
  add_foreign_key "templates", "users", column: "creator_id"
end
