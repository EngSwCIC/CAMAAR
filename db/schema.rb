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

ActiveRecord::Schema[7.1].define(version: 2024_06_11_180454) do
  create_table "questions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "text"
    t.string "type"
    t.bigint "template_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_questions_on_template_id"
  end

  create_table "templates", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "email", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at", null: false
    t.string "salt", null: false
    t.string "password", null: false
    t.string "session_key"
  end

  add_foreign_key "questions", "templates"
end
