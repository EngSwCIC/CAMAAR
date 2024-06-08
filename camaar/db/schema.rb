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

ActiveRecord::Schema[7.1].define(version: 2024_06_08_220346) do
  create_table "formularios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nome"
    t.integer "turma_id", null: false
    t.integer "template_id", null: false
    t.index ["template_id"], name: "index_formularios_on_template_id"
    t.index ["turma_id"], name: "index_formularios_on_turma_id"
  end

  create_table "materia", force: :cascade do |t|
    t.string "codigo"
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matriculas", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "turma_id", null: false
    t.index ["turma_id"], name: "index_matriculas_on_turma_id"
    t.index ["user_id"], name: "index_matriculas_on_user_id"
  end

  create_table "questaos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "texto"
    t.integer "formularios_id", null: false
    t.integer "templates_id", null: false
    t.index ["formularios_id"], name: "index_questaos_on_formularios_id"
    t.index ["templates_id"], name: "index_questaos_on_templates_id"
  end

  create_table "resposta", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "texto"
    t.integer "questao_id", null: false
    t.integer "formulario_id", null: false
    t.index ["formulario_id"], name: "index_resposta_on_formulario_id"
    t.index ["questao_id"], name: "index_resposta_on_questao_id"
  end

  create_table "templates", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "turmas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "codigo"
    t.string "semestre"
    t.string "horario"
    t.integer "materia_id", null: false
    t.index ["materia_id"], name: "index_turmas_on_materia_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "nome"
    t.string "email"
    t.string "curso"
    t.string "matricula"
    t.string "formacao"
    t.string "ocupacao"
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "formularios", "templates"
  add_foreign_key "formularios", "turmas"
  add_foreign_key "matriculas", "turmas"
  add_foreign_key "matriculas", "users"
  add_foreign_key "questaos", "formularios", column: "formularios_id"
  add_foreign_key "questaos", "templates", column: "templates_id"
  add_foreign_key "resposta", "formularios"
  add_foreign_key "resposta", "questaos"
  add_foreign_key "turmas", "materia", column: "materia_id"
end
