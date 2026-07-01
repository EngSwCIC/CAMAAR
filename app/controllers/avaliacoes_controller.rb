# Controller para o painel de avaliações do discente
class AvaliacoesController < ApplicationController
  layout "dashboard"
  before_action :set_turma_and_form, only: [:show, :detalhes, :responder]

  # Lista as turmas com formulários disponíveis para o usuário logado
  #
  # Argumentos: Nenhum
  # Retorno: Nenhum (renderiza view)
  # Efeitos colaterais: Nenhum
  def index
    turmas_ids = current_user.turmas.pluck(:id)
    @turmas_com_form = Turma
      .joins(:forms)
      .where(id: turmas_ids, forms: { destinatario: current_user.role })
      .includes(:disciplina)
      .distinct
  end

  # Retorna o formulário mais recente destinado ao papel do usuário atual,
  # associado à turma
  #
  # Argumentos: turma (Turma)
  # Retorno: Form ou nil
  def form_for(turma)
    turma.forms.where(destinatario: current_user.role).order(created_at: :desc).first
  end
  helper_method :form_for

  # Verifica se o usuário atual já respondeu o formulário informado
  #
  # Argumentos: form (Form)
  # Retorno: Booleano
  def respondido?(form)
    form && FormResponse.exists?(form: form, user: current_user)
  end
  helper_method :respondido?

  # Exibe os detalhes de um formulário (turma, template, datas, quantidade
  # de questões) antes do discente decidir respondê-lo
  #
  # Argumentos: params[:id] — id da Turma
  # Retorno: Nenhum (renderiza view)
  # Efeitos colaterais: Nenhum
  def detalhes
    return if @form.nil?

    @questions = @form.template.questions
    redirect_to avaliacoes_path, alert: "Você já respondeu esta avaliação" if ja_respondeu?
  end

  # Exibe o formulário de avaliação de uma turma para o discente responder
  #
  # Argumentos: params[:id] — id da Turma
  # Retorno: Nenhum (renderiza view)
  # Efeitos colaterais: Nenhum
  def show
    return if @form.nil?

    @questions = @form.template.questions
    redirect_to avaliacoes_path, alert: "Você já respondeu esta avaliação" if ja_respondeu?
  end

  # Processa a submissão das respostas do discente
  #
  # Argumentos: params[:id] — id da Turma; params[:answers] — hash de respostas
  # Retorno: Nenhum (redireciona)
  # Efeitos colaterais: Cria FormResponse no banco
  def responder
    return if @form.nil?
    return if validacao_falhou?

    FormResponse.create!(
      form:    @form,
      user:    current_user,
      turma:   @turma,
      answers: build_answers
    )

    redirect_to avaliacoes_path, notice: "Avaliação submetida com sucesso!"
  rescue => e
    flash.now[:alert] = "Erro ao enviar avaliação: #{e.message}"
    @questions = @form.template.questions
    render "avaliacoes/show", status: :unprocessable_entity
  end

  private

  def set_turma_and_form
    @turma = Turma.find(params[:id])
    return redirect_to avaliacoes_path, alert: "Você não está matriculado nesta turma" unless matriculado_na_turma?

    @form = @turma.forms.where("end_date > ?", Time.current).where(destinatario: current_user.role).first
    redirect_para_formulario_expirado if @form.nil?
  end

  # Verifica se o usuário logado está matriculado na turma atual
  #
  # Argumentos: Nenhum (usa @turma e current_user)
  # Retorno: Booleano
  def matriculado_na_turma?
    TurmaMembership.exists?(turma: @turma, user: current_user)
  end

  # Redireciona informando a data em que o formulário mais recente destinado
  # ao papel do usuário expirou, ou uma mensagem genérica caso nenhum
  # formulário desse tipo tenha existido para a turma (inclusive quando o
  # único formulário existente é destinado a outro papel, ex.: docente
  # tentando acessar formulário de dicente e vice-versa)
  #
  # Argumentos: Nenhum (usa @turma e current_user)
  # Retorno: Nenhum
  # Efeitos colaterais: Redireciona com flash de alerta
  def redirect_para_formulario_expirado
    formulario_expirado = @turma.forms.where(destinatario: current_user.role).order(end_date: :desc).first

    if formulario_expirado
      redirect_to avaliacoes_path, alert: "Este formulário expirou em #{formulario_expirado.end_date.strftime('%d/%m/%Y')}"
    else
      redirect_to avaliacoes_path, alert: "Formulário não disponível"
    end
  end

  # Realiza as validações necessárias antes de salvar a resposta.
  #
  # Argumentos: Nenhum
  # Retorno: Booleano indicando se alguma validação falhou (true) ou não (false)
  # Efeitos Colaterais: Configura alertas no flash e renderiza/redireciona a página em caso de falha.
  def validacao_falhou?
    return true if ja_respondeu_validacao?
    return true if questoes_obrigatorias_faltando?
    false
  end

  # Verifica se o usuário já respondeu este formulário.
  #
  # Argumentos: Nenhum
  # Retorno: Booleano
  def ja_respondeu?
    FormResponse.exists?(form: @form, user: current_user)
  end

  # Verifica se o usuário já respondeu este formulário e redireciona se sim.
  #
  # Argumentos: Nenhum
  # Retorno: Booleano
  # Efeitos Colaterais: Redireciona e gera alerta se já respondeu.
  def ja_respondeu_validacao?
    if ja_respondeu?
      redirect_to avaliacoes_path, alert: "Você já respondeu esta avaliação"
      true
    else
      false
    end
  end

  # Verifica se falta alguma resposta a questão obrigatória.
  #
  # Argumentos: Nenhum
  # Retorno: Booleano
  # Efeitos Colaterais: Renderiza erro com status unprocessable_entity se faltar resposta.
  def questoes_obrigatorias_faltando?
    @questions = @form.template.questions
    @missing_question_ids = @questions.select do |question|
      question.obrigatoria? && (params[:answers].blank? || params[:answers][question.id.to_s].blank?)
    end.map(&:id)

    if @missing_question_ids.any?
      flash.now[:alert] = "Por favor, responda todas as questões obrigatórias"
      render "avaliacoes/show", status: :unprocessable_entity
      true
    else
      false
    end
  end

  # Monta o array de respostas a partir dos params, no formato
  # { "question_id" => ..., "value" => ... } usado por FormResponse#answers
  # (e consumido, por exemplo, na exportação de CSV dos resultados).
  #
  # Argumentos: Nenhum
  # Retorno: Array de Hash
  def build_answers
    return [] unless params[:answers].is_a?(ActionController::Parameters)

    params[:answers].to_unsafe_h.map do |question_id, value|
      {
        "question_id" => question_id.to_i,
        "value"       => value.is_a?(String) ? value : value.to_h
      }
    end
  end
end
