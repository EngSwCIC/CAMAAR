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

ActiveRecord::Schema[7.0].define(version: 2022_04_23_111156) do
  create_table "answers", force: :cascade do |t|
    t.integer "member_id", null: false
    t.integer "option_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "code"
    t.index ["member_id"], name: "index_answers_on_member_id"
    t.index ["option_id"], name: "index_answers_on_option_id"
  end

  create_table "cclasses", force: :cascade do |t|
    t.string "code"
    t.string "semester"
    t.string "time"
    t.integer "subject_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_cclasses_on_subject_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer "cclass_id", null: false
    t.integer "member_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cclass_id"], name: "index_enrollments_on_cclass_id"
    t.index ["member_id"], name: "index_enrollments_on_member_id"
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "members", force: :cascade do |t|
    t.string "name", null: false
    t.string "registration", null: false
    t.string "username", null: false
    t.string "occupation", null: false
    t.string "degree", null: false
    t.string "course", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registration"], name: "index_members_on_registration", unique: true
  end

  create_table "options", force: :cascade do |t|
    t.integer "question_id", null: false
    t.string "description"
    t.boolean "in_blank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "code"
    t.index ["question_id"], name: "index_options_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "code"
    t.integer "survey_id", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_questions_on_survey_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_subjects_on_code", unique: true
    t.index ["name"], name: "index_subjects_on_name", unique: true
  end

  create_table "surveys", force: :cascade do |t|
    t.integer "code"
    t.string "name"
    t.integer "cclass_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cclass_id"], name: "index_surveys_on_cclass_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "member_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["member_id"], name: "index_users_on_member_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "answers", "members"
  add_foreign_key "answers", "options"
  add_foreign_key "cclasses", "subjects"
  add_foreign_key "enrollments", "cclasses"
  add_foreign_key "enrollments", "members"
  add_foreign_key "options", "questions"
  add_foreign_key "questions", "surveys"
  add_foreign_key "surveys", "cclasses"
  add_foreign_key "users", "members"
end
