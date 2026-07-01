# frozen_string_literal: true

require "csv"

module Formularios
  class CSVExport
    def self.call(formulario:)
      new(formulario: formulario).call
    end

    def initialize(formulario:)
      @formulario = formulario
    end

    def call
      CSV.generate(headers: true, col_sep: ";") do |csv|
        csv << header
        evaluations_with_answers.each { |avaliacao| csv << row_for(avaliacao) }
      end
    end

    def filename
      "resultados_turma_#{formulario.turma.materia.codigo}_#{Date.current}.csv"
    end

    private

    attr_reader :formulario

    def header
      [ "Aluno", "Matrícula", *questions.map(&:enunciado) ]
    end

    def row_for(avaliacao)
      usuario = avaliacao.participacao_turma.usuario
      [ usuario.nome, usuario.matricula.presence || "N/A", *answer_values(avaliacao) ]
    end

    def answer_values(avaliacao)
      questions.map do |question|
        answer_value(answer_for(avaliacao, question), question)
      end
    end

    def answer_for(avaliacao, question)
      avaliacao.respostas.find { |answer| answer.questao_id == question.id }
    end

    def answer_value(answer, question)
      return "Sem resposta" if answer.nil?
      return answer.texto&.texto.to_s.strip if question.discursiva?

      answer.opcoes_escolhidas.map { |opcao_escolhida| opcao_escolhida.opcao.texto }.join(", ")
    end

    def questions
      @questions ||= formulario.questoes.order(:id)
    end

    def evaluations_with_answers
      formulario.avaliacoes
        .joins(:respostas)
        .distinct
        .includes(
          participacao_turma: :usuario,
          respostas: [ :questao, :texto, { opcoes_escolhidas: :opcao } ]
        )
    end
  end
end
