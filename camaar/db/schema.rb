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

ActiveRecord::Schema[7.1].define(version: 2024_06_11_135913) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dicentes", force: :cascade do |t|
    t.string "matricula", null: false
    t.string "curso", null: false
    t.string "turma", default: [], array: true
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_dicentes_on_user_id"
  end

  create_table "docentes", force: :cascade do |t|
    t.string "departamento", null: false
    t.string "formularios", default: [], array: true
    t.string "templates", default: [], array: true
    t.string "turmas", default: [], array: true
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_docentes_on_user_id"
  end

  create_table "formularios", force: :cascade do |t|
    t.string "nome", null: false
    t.string "turmas", default: [], array: true
    t.date "dataDeTermino", null: false
    t.jsonb "resultados", default: {}
    t.bigint "docente_id", null: false
    t.bigint "questao_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["docente_id"], name: "index_formularios_on_docente_id"
    t.index ["questao_id"], name: "index_formularios_on_questao_id"
  end

  create_table "questaos", force: :cascade do |t|
    t.string "pergunta", null: false
    t.jsonb "alternativas", default: {}, null: false
    t.decimal "pontos", precision: 10, scale: 2, null: false
    t.decimal "fatorDeCorrecao", precision: 10, scale: 2, default: "0.0", null: false
    t.string "alternativaCorreta", null: false
    t.bigint "template_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "formulario_id"
    t.index ["formulario_id"], name: "index_questaos_on_formulario_id"
    t.index ["template_id"], name: "index_questaos_on_template_id"
  end

  create_table "templates", force: :cascade do |t|
    t.string "nome", null: false
    t.integer "numeroDeAlternativas", null: false
    t.boolean "discursiva", null: false
    t.boolean "fatorDeCorrecao", null: false
    t.bigint "docente_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["docente_id"], name: "index_templates_on_docente_id"
  end

  create_table "turmas", force: :cascade do |t|
    t.string "codigo", null: false
    t.string "nome_materia", null: false
    t.string "semestre", null: false
    t.string "horario", null: false
    t.string "dicentes", default: [], array: true
    t.string "formularios", default: [], array: true
    t.bigint "docente_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["docente_id"], name: "index_turmas_on_docente_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "nome", null: false
    t.string "email", null: false
    t.string "senha", null: false
    t.string "type", default: "Dicente", null: false
    t.string "usuario", null: false
    t.string "formacao", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "dicentes", "users"
  add_foreign_key "docentes", "users"
  add_foreign_key "formularios", "docentes"
  add_foreign_key "formularios", "questaos"
  add_foreign_key "questaos", "formularios"
  add_foreign_key "questaos", "templates"
  add_foreign_key "templates", "docentes"
  add_foreign_key "turmas", "docentes"
end
