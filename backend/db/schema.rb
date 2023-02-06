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

ActiveRecord::Schema[7.0].define(version: 2023_02_06_161745) do
  create_table "cclasses", force: :cascade do |t|
    t.string "code"
    t.string "semester"
    t.string "time"
    t.bigint "subject_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_cclasses_on_subject_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.bigint "cclass_id", null: false
    t.bigint "member_id", null: false
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

  create_table "likert_scale_answers", force: :cascade do |t|
    t.integer "answer"
    t.bigint "likert_scale_question_id"
    t.bigint "question_answer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["likert_scale_question_id"], name: "index_likert_scale_answers_on_likert_scale_question_id"
    t.index ["question_answer_id"], name: "index_likert_scale_answers_on_question_answer_id"
  end

  create_table "likert_scale_questions", force: :cascade do |t|
    t.text "question"
    t.integer "question_number"
    t.integer "scale_points"
    t.bigint "survey_question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_question_id"], name: "index_likert_scale_questions_on_survey_question_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "name", null: false
    t.string "registration", null: false
    t.string "username", null: false
    t.string "degree", null: false
    t.string "course", null: false
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role_id"
    t.string "redefinition_link"
    t.index ["registration"], name: "index_members_on_registration", unique: true
    t.index ["role_id"], name: "index_members_on_role_id"
  end

  create_table "question_answers", force: :cascade do |t|
    t.text "answer"
    t.bigint "survey_answer_id"
    t.bigint "survey_question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_answer_id"], name: "index_question_answers_on_survey_answer_id"
    t.index ["survey_question_id"], name: "index_question_answers_on_survey_question_id"
  end

  create_table "question_options", force: :cascade do |t|
    t.integer "option_number"
    t.text "content"
    t.bigint "survey_question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_question_id"], name: "index_question_options_on_survey_question_id"
  end

  create_table "question_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subjects", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_subjects_on_code", unique: true
    t.index ["name"], name: "index_subjects_on_name", unique: true
  end

  create_table "survey_answers", force: :cascade do |t|
    t.bigint "survey_id", null: false
    t.bigint "member_id", null: false
    t.bigint "cclass_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cclass_id"], name: "index_survey_answers_on_cclass_id"
    t.index ["member_id"], name: "index_survey_answers_on_member_id"
    t.index ["survey_id"], name: "index_survey_answers_on_survey_id"
  end

  create_table "survey_questions", force: :cascade do |t|
    t.text "question"
    t.integer "question_number"
    t.boolean "optional", default: false
    t.bigint "survey_id"
    t.bigint "question_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_type_id"], name: "index_survey_questions_on_question_type_id"
    t.index ["survey_id"], name: "index_survey_questions_on_survey_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "expiration_date"
    t.string "semester"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role_id"
    t.index ["role_id"], name: "index_surveys_on_role_id"
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

  add_foreign_key "cclasses", "subjects"
  add_foreign_key "enrollments", "cclasses"
  add_foreign_key "enrollments", "members"
  add_foreign_key "likert_scale_answers", "likert_scale_questions"
  add_foreign_key "likert_scale_answers", "question_answers"
  add_foreign_key "likert_scale_questions", "survey_questions"
  add_foreign_key "members", "roles"
  add_foreign_key "question_answers", "survey_answers"
  add_foreign_key "question_answers", "survey_questions"
  add_foreign_key "question_options", "survey_questions"
  add_foreign_key "survey_answers", "cclasses"
  add_foreign_key "survey_answers", "members"
  add_foreign_key "survey_answers", "surveys"
  add_foreign_key "survey_questions", "question_types"
  add_foreign_key "survey_questions", "surveys"
  add_foreign_key "surveys", "roles"
  add_foreign_key "users", "members"
end
