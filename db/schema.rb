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

ActiveRecord::Schema[8.1].define(version: 2026_06_16_231812) do

  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "departamento_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["departamento_id"], name: "index_admins_on_departamento_id"
    t.index ["user_id", "departamento_id"], name: "index_admins_on_user_id_and_departamento_id", unique: true
    t.index ["user_id"], name: "index_admins_on_user_id"
  end

  create_table "departamentos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nome", null: false
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_departamentos_on_nome", unique: true
  end

  create_table "templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nome", null: false
    t.string "semestre", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_templates_on_user_id"
  end

  create_table "turmas", force: :cascade do |t|
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.integer "departamento_id", null: false
    t.string "nome", null: false
    t.datetime "updated_at", null: false
    t.index ["departamento_id"], name: "index_turmas_on_departamento_id"
  end


  create_table "dado_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "curso"
    t.string "email"
    t.string "formacao"
    t.string "matricula"
    t.string "nome"
    t.string "ocupacao"
    t.datetime "updated_at", null: false
    t.string "usuario"
  end

  create_table "discentes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "curso"
    t.string "email"
    t.string "formacao"
    t.string "matricula"
    t.string "nome"
    t.string "ocupacao"
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
    t.string "usuario"
    t.index ["turma_id"], name: "index_discentes_on_turma_id"
  end

  create_table "docentes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "departamento"
    t.string "email"
    t.string "formacao"
    t.string "nome"
    t.string "ocupacao"
    t.string "turma"
    t.datetime "updated_at", null: false
    t.string "usuario"
  end

  create_table "turmas", force: :cascade do |t|
    t.string "codigo"
    t.datetime "created_at", null: false
    t.string "semestre"
    t.string "turma"
    t.datetime "updated_at", null: false
  end



  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "matricula", null: false
    t.string "nome", null: false
    t.string "password_digest"
    t.string "perfil", null: false
    t.boolean "primeiro_acesso", default: true, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["matricula"], name: "index_users_on_matricula", unique: true
  end

  add_foreign_key "admins", "departamentos"
  add_foreign_key "admins", "users"
  add_foreign_key "templates", "users"
  add_foreign_key "turmas", "departamentos"

  add_foreign_key "discentes", "turmas"
end
