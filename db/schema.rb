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

ActiveRecord::Schema[8.0].define(version: 2025_07_13_204544) do
  create_table "cargos", id: false, force: :cascade do |t|
    t.string "email", null: false
    t.integer "funcao", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email", "funcao"], name: "index_cargos_on_email_and_funcao", unique: true
  end

  create_table "formulario_respondidos", id: false, force: :cascade do |t|
    t.string "email", null: false
    t.integer "formulario_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["formulario_id"], name: "index_formulario_respondidos_on_formulario_id"
  end

  create_table "formularios", force: :cascade do |t|
    t.integer "ligacao_pergunta_id", null: false
    t.integer "turma_id", null: false
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ligacao_pergunta_id"], name: "index_formularios_on_ligacao_pergunta_id"
    t.index ["turma_id"], name: "index_formularios_on_turma_id"
  end

  create_table "ligacao_perguntas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "materias", id: :string, force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "opcoes", primary_key: ["pergunta_id", "item"], force: :cascade do |t|
    t.integer "pergunta_id", null: false
    t.integer "item", null: false
    t.text "opcao", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "participantes", primary_key: ["email", "id_turma"], force: :cascade do |t|
    t.text "email", null: false
    t.integer "id_turma", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "perguntas", force: :cascade do |t|
    t.integer "ligacao_pergunta_id", null: false
    t.integer "tipo", null: false
    t.string "pergunta", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ligacao_pergunta_id"], name: "index_perguntas_on_ligacao_pergunta_id"
  end

  create_table "pessoas", primary_key: "email", id: :string, force: :cascade do |t|
    t.string "nome"
    t.string "matricula"
    t.string "senha"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["reset_password_token"], name: "index_pessoas_on_reset_password_token", unique: true
  end

  create_table "respostas", force: :cascade do |t|
    t.integer "formulario_id", null: false
    t.integer "pergunta_id", null: false
    t.string "conteudo", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["formulario_id"], name: "index_respostas_on_formulario_id"
    t.index ["pergunta_id"], name: "index_respostas_on_pergunta_id"
  end

  create_table "templates", force: :cascade do |t|
    t.integer "ligacao_pergunta_id", null: false
    t.string "nome", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ligacao_pergunta_id"], name: "index_templates_on_ligacao_pergunta_id"
  end

  create_table "turmas", force: :cascade do |t|
    t.string "semestre"
    t.integer "numero_turma"
    t.string "professor"
    t.string "id_materia"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "cargos", "pessoas", column: "email", primary_key: "email"
  add_foreign_key "formulario_respondidos", "formularios"
  add_foreign_key "formulario_respondidos", "pessoas", column: "email", primary_key: "email"
  add_foreign_key "formularios", "ligacao_perguntas"
  add_foreign_key "formularios", "turmas"
  add_foreign_key "opcoes", "perguntas"
  add_foreign_key "participantes", "pessoas", column: "email", primary_key: "email"
  add_foreign_key "participantes", "turmas", column: "id_turma"
  add_foreign_key "perguntas", "ligacao_perguntas"
  add_foreign_key "respostas", "formularios"
  add_foreign_key "respostas", "perguntas"
  add_foreign_key "templates", "ligacao_perguntas"
  add_foreign_key "turmas", "materias", column: "id_materia"
end
