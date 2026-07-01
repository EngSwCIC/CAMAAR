# frozen_string_literal: true

module Avaliacoes
  class SubmitResponse
    Result = Struct.new(:status, keyword_init: true) do
      def already_answered?
        status == :already_answered
      end

      def success?
        status == :success
      end
    end

    def self.call(avaliacao:, respostas_params:)
      new(avaliacao: avaliacao, respostas_params: respostas_params).call
    end

    def self.questions_for(avaliacao)
      avaliacao.formulario.questoes.includes(:opcoes).order(:id)
    end

    def initialize(avaliacao:, respostas_params:)
      @avaliacao = avaliacao
      @respostas_params = respostas_params || {}
    end

    def call
      return Result.new(status: :already_answered) if avaliacao.respondida?
      return Result.new(status: :invalid) unless all_required_answered?

      save_answers
      Result.new(status: :success)
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound
      Result.new(status: :invalid)
    end

    private

    attr_reader :avaliacao, :respostas_params

    def all_required_answered?
      questions.all? do |question|
        answer_filled?(question, answer_data_for(question))
      end
    end

    def answer_filled?(question, answer_data)
      return answer_data["texto"].to_s.strip.present? if question.discursiva?

      Array(answer_data["opcao_id"]).any?(&:present?)
    end

    def save_answers
      ActiveRecord::Base.transaction do
        questions.each { |question| save_answer(question, answer_data_for(question)) }
        avaliacao.marcar_como_respondida!
      end
    end

    def save_answer(question, answer_data)
      resposta = Resposta.find_or_initialize_by(avaliacao: avaliacao, questao: question)
      fill_answer(resposta, question, answer_data)
      resposta.save!
    end

    def fill_answer(resposta, question, answer_data)
      if question.discursiva?
        resposta.build_texto(texto: answer_data["texto"].to_s.strip)
      else
        resposta.opcoes_escolhidas.build(opcao: question.opcoes.find(answer_data["opcao_id"].to_s))
      end
    end

    def answer_data_for(question)
      respostas_params[question.id.to_s] || {}
    end

    def questions
      @questions ||= self.class.questions_for(avaliacao)
    end
  end
end
