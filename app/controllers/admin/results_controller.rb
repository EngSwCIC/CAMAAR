require "csv"

# Controller para visualização e download de resultados de formulários
class Admin::ResultsController < ApplicationController
  before_action :require_admin
  layout "dashboard"
  before_action :set_turma, only: [:show, :csv]

  # Lista turmas que possuem formulários com respostas
  #
  # Argumentos: Nenhum
  # Retorno: Nenhum (renderiza view)
  # Efeitos colaterais: Nenhum
  def index
    @turmas = Turma.includes(:disciplina, :docentes).joins(:forms).distinct
  end

  # Exibe detalhes de resultados de uma turma específica
  #
  # Argumentos: params[:id] — id da Turma
  # Retorno: Nenhum (renderiza view)
  # Efeitos colaterais: Nenhum
  def show
    @responses = FormResponse.where(turma: @turma).includes(:user, form: { template: :questions })
    @form      = @turma.forms.order(created_at: :desc).first
    @template  = @form&.template
    @question_summaries = build_question_summaries(@responses, @template)
  end

  # Gera e faz download de CSV com as respostas da turma
  #
  # Argumentos: params[:id] — id da Turma
  # Retorno: Arquivo CSV
  # Efeitos colaterais: Envia arquivo ao cliente
  def csv
    responses = FormResponse.where(turma: @turma).includes(:user, form: { template: :questions })

    if responses.empty?
      return redirect_to admin_result_path(@turma), alert: "Esta turma ainda não possui respostas registradas"
    end

    send_data build_csv(responses),
      type:        "text/csv; charset=utf-8",
      filename:    "resultados_turma_#{@turma.id}.csv",
      disposition: "attachment"
  end

  private

  def set_turma
    @turma = Turma.includes(:disciplina, :docentes).find(params[:id])
  end

  # Gera CSV com colunas Turma, Discente, Questão, Resposta
  #
  # Argumentos: responses (ActiveRecord::Relation)
  # Retorno: String com conteúdo CSV
  # Efeitos colaterais: Nenhum
  def build_csv(responses)
    CSV.generate(headers: true) do |csv|
      csv << %w[Turma Discente Questão Resposta]
      responses.each { |fr| append_response_rows(csv, fr) }
    end
  end

  # Adiciona linhas de um FormResponse ao CSV
  #
  # Argumentos: csv (CSV), fr (FormResponse)
  # Retorno: Nenhum
  # Efeitos colaterais: Modifica csv in-place
  def append_response_rows(csv, fr)
    answers = Array(fr.answers)
    return csv << empty_row(fr) if answers.empty?

    questions = questions_for(fr)
    answers.each { |ans| csv << answer_row(fr, questions, ans) }
  end

  # Retorna linha vazia para respostas sem dados
  #
  # Argumentos: fr (FormResponse)
  # Retorno: Array com campos da linha
  # Efeitos colaterais: Nenhum
  def empty_row(fr)
    [@turma.classCode, fr.user&.nome.to_s, "", ""]
  end

  # Retorna linha preenchida para uma resposta
  #
  # Argumentos: fr (FormResponse), questions (Array), ans (Hash)
  # Retorno: Array com campos da linha
  # Efeitos colaterais: Nenhum
  def answer_row(fr, questions, ans)
    question = questions.find { |q| q.id == ans["question_id"] }
    [@turma.classCode, fr.user&.nome.to_s, question&.text.to_s, ans["value"].to_s]
  end

  # Retorna as questões associadas ao FormResponse
  #
  # Argumentos: fr (FormResponse)
  # Retorno: Array de Question
  # Efeitos colaterais: Nenhum
  def questions_for(fr)
    fr.form&.template&.questions || []
  end

  # Monta um resumo por questão: contagem de opções para Radio,
  # lista de respostas para Texto
  #
  # Argumentos: responses (ActiveRecord::Relation), template (Template ou nil)
  # Retorno: Array de Hash
  # Efeitos colaterais: Nenhum
  def build_question_summaries(responses, template)
    return [] unless template

    template.questions.map do |question|
      valores = collect_values(responses, question)
      {
        question:      question,
        option_counts: question.kind == "radio" ? tally_options(question, valores) : nil,
        respostas:     question.kind == "radio" ? nil : valores
      }
    end
  end

  # Coleta os valores de resposta de uma questão específica
  #
  # Argumentos: responses (ActiveRecord::Relation), question (Question)
  # Retorno: Array de Hash com value/user/created_at
  # Efeitos colaterais: Nenhum
  def collect_values(responses, question)
    responses.flat_map do |fr|
      Array(fr.answers)
        .select { |a| a["question_id"] == question.id }
        .map { |a| { value: a["value"], user: fr.user&.nome, created_at: fr.created_at } }
    end
  end

  # Conta as respostas recebidas para cada opção de uma questão Radio
  #
  # Argumentos: question (Question), valores (Array de Hash)
  # Retorno: Hash opção => contagem
  # Efeitos colaterais: Nenhum
  def tally_options(question, valores)
    base = Array(question.options).index_with(0)
    base.merge(valores.group_by { |v| v[:value] }.transform_values(&:size))
  end
end
