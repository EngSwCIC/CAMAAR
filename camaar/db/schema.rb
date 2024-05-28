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

ActiveRecord::Schema[7.1].define(version: 2024_05_28_162152) do
  create_table "coordinators", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_coordinators_on_email", unique: true
  end

  create_table "forms", force: :cascade do |t|
    t.json "questions"
    t.string "role", default: "Student"
    t.boolean "open", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "student_answers", force: :cascade do |t|
    t.json "answers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", force: :cascade do |t|
    t.integer "registration"
    t.string "name"
    t.string "course"
    t.string "formation"
    t.string "occupation"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_students_on_email", unique: true
    t.index ["registration"], name: "index_students_on_registration", unique: true
  end

  create_table "subject_classes", force: :cascade do |t|
    t.string "semester"
    t.string "subject"
    t.string "code"
    t.string "name"
    t.string "schedule"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teacher_answers", force: :cascade do |t|
    t.json "answers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teachers", force: :cascade do |t|
    t.integer "registration"
    t.string "name"
    t.string "formation"
    t.string "occupation"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_teachers_on_email", unique: true
    t.index ["registration"], name: "index_teachers_on_registration", unique: true
  end

  create_table "templates", force: :cascade do |t|
    t.string "name"
    t.json "questions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
