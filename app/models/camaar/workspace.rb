require "securerandom"

module Camaar
  class Workspace
    DEFAULT_STATE = {
      "templates" => [
        {
          "id" => "template-1",
          "title" => "Template 1",
          "semester" => "semestre",
          "questions" => [
            {
              "id" => "template-1-q1",
              "title" => "Questão 1",
              "type" => "radio",
              "options" => [ "Ótimo", "Bom", "Regular", "Ruim" ]
            },
            {
              "id" => "template-1-q2",
              "title" => "Questão 2",
              "type" => "text",
              "options" => []
            }
          ]
        }
      ],
      "forms" => [
        {
          "id" => "form-1",
          "title" => "Avaliação de Turma 2026.1",
          "semester" => "2026.1",
          "professor" => "Professor",
          "template_id" => "template-1",
          "audience" => "aluno",
          "active" => true,
          "questions" => [
            {
              "id" => "form-1-q1",
              "title" => "Como você avalia o professor?",
              "type" => "radio",
              "options" => [ "Ótimo", "Bom", "Regular", "Ruim" ]
            }
          ],
          "responses" => []
        },
        {
          "id" => "form-2",
          "title" => "Nome da matéria",
          "semester" => "semestre",
          "professor" => "Professor",
          "template_id" => "template-1",
          "audience" => "aluno",
          "active" => true,
          "questions" => [
            {
              "id" => "form-2-q1",
              "title" => "Como você avalia o ambiente da disciplina?",
              "type" => "radio",
              "options" => [ "Ótimo", "Bom", "Regular", "Ruim" ]
            }
          ],
          "responses" => []
        }
      ]
    }.freeze

    def initialize(_session = nil)
      @record = WorkspaceState.instance
      @record.data ||= DEFAULT_STATE.deep_dup
      @record.save! if @record.new_record?
    end

    def state
      @record.data
    end

    def templates
      state["templates"]
    end

    def forms
      state["forms"]
    end

    def recipients
      state["recipients"]
    end

    def pending_forms
      forms.select { |form| form["active"] && form["responses"].empty? }
    end

    def find_template(id)
      templates.find { |template| template["id"] == id.to_s }
    end

    def find_form(id)
      forms.find { |form| form["id"] == id.to_s }
    end

    def create_template(payload)
      title = payload["title"].to_s.strip
      raise ArgumentError, "Título não pode ficar em branco!" if title.blank?

      questions = normalize_questions(payload["questions"])
      raise ArgumentError, "Template deve ter pelo menos um elemento!" if questions.empty?

      template = {
        "id" => SecureRandom.uuid,
        "title" => title,
        "semester" => payload["semester"].presence || "semestre",
        "questions" => questions
      }

      templates.unshift(template)
      persist!
      template
    end

    def update_template(id, payload)
      template = find_template(id)
      raise ArgumentError, "Template não encontrado" unless template

      title = payload["title"].to_s.strip
      raise ArgumentError, "Título não pode ficar em branco!" if title.blank?

      questions = normalize_questions(payload["questions"])
      raise ArgumentError, "Template deve ter pelo menos um elemento!" if questions.empty?

      template["title"] = title
      template["semester"] = payload["semester"].presence || template["semester"]
      template["questions"] = questions
      persist!
      template
    end

    def delete_template(id)
      templates.reject! { |template| template["id"] == id.to_s }
      persist!
    end

    def create_form(payload)
      title = payload["title"].to_s.strip
      raise ArgumentError, "Título não pode ficar em branco!" if title.blank?

      template = find_template(payload["template_id"])
      raise ArgumentError, "Template não encontrado" unless template

      form = {
        "id" => SecureRandom.uuid,
        "title" => title,
        "semester" => payload["semester"].presence || template["semester"],
        "professor" => payload["professor"].presence || "Professor",
        "template_id" => template["id"],
        "audience" => payload["audience"].presence || "aluno",
        "active" => true,
        "questions" => template["questions"].map(&:deep_dup),
        "recipients" => Array(payload["recipients"]).map(&:to_s).reject(&:blank?),
        "responses" => []
      }

      forms.unshift(form)
      persist!
      form
    end

    def record_response(form_id, payload)
      form = find_form(form_id)
      raise ArgumentError, "Formulário não encontrado" unless form

      answers = payload["answers"] || {}
      missing_questions = form["questions"].select do |question|
        answer = answers[question["id"]]
        question["type"] == "text" ? answer.to_s.strip.blank? : answer.to_s.strip.blank?
      end

      if missing_questions.any?
        raise ArgumentError, "Por favor, responda todas as perguntas obrigatórias"
      end

      form["responses"] << {
        "id" => SecureRandom.uuid,
        "comment" => payload["comment"].to_s.strip,
        "answers" => answers,
        "created_at" => Time.current.iso8601
      }
      persist!
      form
    end

    def persist!
      @record.update!(data: state)
    end

    private

    def normalize_questions(raw_questions)
      questions_array = raw_questions.is_a?(Hash) ? raw_questions.values : Array(raw_questions)
      questions_array.filter_map do |question|
        next if question.nil?

        title = question["title"].to_s.strip
        type = question["type"].to_s
        options = Array(question["options"]).flat_map { |option| option.to_s.split(",") }.map(&:strip).reject(&:blank?)

        next if title.blank?
        next if type == "radio" && options.size < 2

        {
          "id" => question["id"].presence || SecureRandom.uuid,
          "title" => title,
          "type" => type.presence || "radio",
          "options" => options,
          "required" => true
        }
      end
    end
  end
end
