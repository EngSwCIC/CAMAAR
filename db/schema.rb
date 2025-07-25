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

ActiveRecord::Schema[8.0].define(version: 2025_07_24_133739) do
  create_table "question_answers", force: :cascade do |t|
    t.integer "template_response_id", null: false
    t.integer "template_question_id", null: false
    t.text "answer_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["template_question_id"], name: "index_question_answers_on_template_question_id"
    t.index ["template_response_id", "template_question_id"], name: "index_answers_on_response_and_question", unique: true
    t.index ["template_response_id"], name: "index_question_answers_on_template_response_id"
  end

  create_table "template_questions", force: :cascade do |t|
    t.integer "template_id", null: false
    t.text "question_text", null: false
    t.string "question_type", null: false
    t.text "options"
    t.boolean "required", default: false
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id", "position"], name: "index_template_questions_on_template_id_and_position"
    t.index ["template_id"], name: "index_template_questions_on_template_id"
  end

  create_table "template_responses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "template_id", null: false
    t.datetime "submitted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_template_responses_on_template_id"
    t.index ["user_id", "template_id"], name: "index_template_responses_on_user_id_and_template_id", unique: true
    t.index ["user_id"], name: "index_template_responses_on_user_id"
  end

  create_table "templates", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_templates_on_name"
    t.index ["user_id"], name: "index_templates_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "password_reset_token"
    t.datetime "password_reset_sent_at", precision: nil
    t.string "remember_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ocupacao"
    t.string "matricula"
    t.string "nome"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["matricula"], name: "index_users_on_matricula", unique: true
    t.index ["ocupacao"], name: "index_users_on_ocupacao"
    t.index ["password_reset_token"], name: "index_users_on_password_reset_token", unique: true
    t.index ["remember_digest"], name: "index_users_on_remember_digest", unique: true
  end

  add_foreign_key "question_answers", "template_questions"
  add_foreign_key "question_answers", "template_responses"
  add_foreign_key "template_questions", "templates"
  add_foreign_key "template_responses", "templates"
  add_foreign_key "template_responses", "users"
  add_foreign_key "templates", "users"
end
