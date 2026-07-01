# Consolida os dois sistemas paralelos de formulário existentes no projeto
# (Formulario/Pergunta/Resposta  x  Form/Template/Question/FormResponse)
# em um único sistema: Form/Template/Question/FormResponse.
#
# O que esta migração faz:
#   1. Adiciona as colunas que faltavam no sistema "vencedor" para cobrir
#      regras de negócio que só existiam no sistema antigo:
#        - questions.obrigatoria   (Pergunta#obrigatoria)
#        - templates.status        (rascunho/publicado — feature #5)
#        - forms.target_audience   (público-alvo — feature #16)
#   2. Migra os dados existentes de formularios/perguntas/respostas para
#      templates/forms/questions/form_responses, preservando o conteúdo.
#   3. Remove as tabelas antigas (formularios, perguntas, respostas).
#
# Esta migração é destrutiva (remove tabelas) e por isso não é reversível
# de forma automática — ver método `down`.
class ConsolidateFormSystems < ActiveRecord::Migration[8.1]
  def up
    add_new_columns
    migrate_legacy_data
    drop_legacy_tables
  end

  def down
    raise ActiveRecord::IrreversibleMigration,
      "Esta migração consolida dois sistemas e remove tabelas legadas; " \
      "não é possível desfazer automaticamente. Restaure a partir de um backup, se necessário."
  end

  private

  # Passo 1 — novas colunas no sistema consolidado
  def add_new_columns
    add_column :questions, :obrigatoria, :boolean, default: false, null: false unless column_exists?(:questions, :obrigatoria)
    add_column :templates, :status, :string, default: "rascunho", null: false unless column_exists?(:templates, :status)
    add_column :forms, :target_audience, :string, default: "ambos", null: false unless column_exists?(:forms, :target_audience)
  end

  # Passo 2 — copia os dados de formularios/perguntas/respostas para o
  # sistema novo, criando um Template "técnico" para cada Formulario
  # (já que Form exige um template_id, e Formulario não tinha essa noção).
  def migrate_legacy_data
    return unless table_exists?(:formularios)

    formulario_rows = select_all("SELECT * FROM formularios")
    return if formulario_rows.empty?

    formulario_rows.each do |formulario|
      template_id = create_legacy_template(formulario)
      pergunta_id_map = create_legacy_questions(formulario, template_id)
      form_id = create_legacy_form(formulario, template_id)
      migrate_legacy_respostas(formulario, form_id, pergunta_id_map)
    end
  end

  # Cria um Template equivalente ao Formulario legado (1 para 1), já
  # publicado, pois o Formulario antigo não tinha conceito de rascunho.
  def create_legacy_template(formulario)
    execute <<~SQL
      INSERT INTO templates (nome, descricao, status, version, created_at, updated_at)
      VALUES (
        #{quote("[Migrado] #{formulario['titulo']}")},
        #{quote(formulario["descricao"])},
        #{quote("publicado")},
        1,
        #{quote(formulario["created_at"])},
        #{quote(formulario["updated_at"])}
      )
    SQL
    select_value("SELECT last_insert_rowid()")
  end

  # Migra as Perguntas do formulario para Questions do novo template.
  # Retorna um hash { pergunta_id_antigo => question_id_novo } para
  # permitir remapear as Respostas no passo seguinte.
  def create_legacy_questions(formulario, template_id)
    perguntas = select_all("SELECT * FROM perguntas WHERE formulario_id = #{formulario['id'].to_i}")
    id_map = {}

    perguntas.each do |pergunta|
      execute <<~SQL
        INSERT INTO questions (template_id, kind, text, obrigatoria, created_at, updated_at)
        VALUES (
          #{template_id},
          #{quote(map_tipo_pergunta(pergunta["tipo_pergunta"]))},
          #{quote(pergunta["enunciado"])},
          #{pergunta["obrigatoria"] ? 1 : 0},
          #{quote(pergunta["created_at"])},
          #{quote(pergunta["updated_at"])}
        )
      SQL
      id_map[pergunta["id"]] = select_value("SELECT last_insert_rowid()")
    end

    id_map
  end

  # Mapeia o tipo_pergunta antigo (texto/multipla_escolha/escala) para o
  # kind novo. "escala" não existia em Question — vira um kind próprio,
  # que precisa ser adicionado à validação do model (ver observação ao final).
  def map_tipo_pergunta(tipo)
    case tipo
    when "multipla_escolha" then "radio"
    when "escala" then "escala"
    else "text"
    end
  end

  # Cria o Form equivalente, associado à turma do Formulario antigo.
  # target_audience fica como "discente", já que o sistema antigo só
  # era usado para o fluxo de resposta dos discentes.
  def create_legacy_form(formulario, template_id)
    execute <<~SQL
      INSERT INTO forms (template_id, start_date, end_date, target_audience, created_at, updated_at)
      VALUES (
        #{template_id},
        #{quote(formulario["created_at"])},
        #{quote(formulario["deadline"])},
        #{quote("discente")},
        #{quote(formulario["created_at"])},
        #{quote(formulario["updated_at"])}
      )
    SQL
    form_id = select_value("SELECT last_insert_rowid()")

    execute <<~SQL
      INSERT INTO forms_turmas (form_id, turma_id)
      VALUES (#{form_id}, #{formulario["turma_id"].to_i})
    SQL

    form_id
  end

  # Agrupa as Respostas antigas por usuário e cria um FormResponse por
  # (form, user), com answers serializado em JSON, no formato já usado
  # por FormResponse#answers em todo o restante do sistema.
  def migrate_legacy_respostas(formulario, form_id, pergunta_id_map)
    respostas = select_all("SELECT * FROM respostas WHERE formulario_id = #{formulario['id'].to_i}")
    respostas.group_by { |r| r["user_id"] }.each do |user_id, user_respostas|
      answers = user_respostas.map do |r|
        {
          "question_id" => pergunta_id_map[r["pergunta_id"]],
          "value"       => r["conteudo"]
        }
      end

      created_at = user_respostas.map { |r| r["created_at"] }.min
      updated_at = user_respostas.map { |r| r["updated_at"] }.max

      execute <<~SQL
        INSERT INTO form_responses (form_id, user_id, turma_id, answers, created_at, updated_at)
        VALUES (
          #{form_id},
          #{user_id.to_i},
          #{formulario["turma_id"].to_i},
          #{quote(answers.to_json)},
          #{quote(created_at)},
          #{quote(updated_at)}
        )
      SQL
    end
  end

  # Passo 3 — remove as tabelas do sistema legado
  def drop_legacy_tables
    drop_table :respostas,    if_exists: true
    drop_table :perguntas,    if_exists: true
    drop_table :formularios,  if_exists: true
  end
end
