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

ActiveRecord::Schema[7.1].define(version: 2024_06_11_155919) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "administradors", force: :cascade do |t|
    t.bigint "users_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "nomes_turmas", default: [], array: true
    t.text "nomes_templates", default: [], array: true
    t.text "nomes_formularios", default: [], array: true
    t.index ["users_id"], name: "index_administradors_on_users_id"
  end

  create_table "alunos", force: :cascade do |t|
    t.string "matricula", null: false
    t.jsonb "nomes_turmas_matriculadas", default: [], null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_alunos_on_user_id"
  end

  create_table "formularios", force: :cascade do |t|
    t.jsonb "turmas", default: []
    t.date "dataDeTermino", null: false
    t.jsonb "resultados", default: {}
    t.bigint "administrador_id", null: false
    t.bigint "questao_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nome", null: false
    t.index ["administrador_id"], name: "index_formularios_on_administrador_id"
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
    t.bigint "administrador_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["administrador_id"], name: "index_templates_on_administrador_id"
  end

  create_table "turmas", force: :cascade do |t|
    t.string "nome_turma", null: false
    t.string "nome_materia", null: false
    t.string "semestre", null: false
    t.jsonb "nomes_alunos", default: []
    t.jsonb "nomes_formularios", default: []
    t.bigint "administrador_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["administrador_id"], name: "index_turmas_on_administrador_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "nome", null: false
    t.string "senha", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", default: "Aluno", null: false
  end

  add_foreign_key "administradors", "users", column: "users_id"
  add_foreign_key "alunos", "users"
  add_foreign_key "formularios", "administradors"
  add_foreign_key "formularios", "questaos"
  add_foreign_key "questaos", "formularios"
  add_foreign_key "questaos", "templates"
  add_foreign_key "templates", "administradors"
  add_foreign_key "turmas", "administradors"
end
