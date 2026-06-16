require 'csv'

class AvaliacoesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!, only: [:new, :create, :resultados, :exportar_csv]
  before_action :set_avaliacao, only: [:show, :responder, :submeter, :resultados, :exportar_csv]
  layout 'authenticated'

  def index
    @avaliacoes = if current_user.admin?
      Avaliacao.includes(:template, :turma).all
    else
      turma_ids = current_user.turmas.pluck(:id)
      Avaliacao.includes(:template, turma: :disciplina)
               .para_discentes
               .where(turma_id: turma_ids)
               .nao_respondidas_por(current_user)
    end
  end

  def show
  end

  def new
    @avaliacao = Avaliacao.new
    @templates = Template.all
    @turmas = Turma.includes(:disciplina).all
  end

  def create
    @avaliacao = Avaliacao.new(avaliacao_params)
    if @avaliacao.save
      redirect_to avaliacoes_path, notice: "Formulário disponibilizado para a turma."
    else
      @templates = Template.all
      @turmas = Turma.includes(:disciplina).all
      render :new, status: :unprocessable_entity
    end
  end

  def responder
    @questoes = @avaliacao.template.questoes
    redirect_to avaliacoes_path, alert: "Você já respondeu este formulário." if ja_respondeu?
  end

  def submeter
    if ja_respondeu?
      redirect_to avaliacoes_path, alert: "Você já respondeu este formulário."
      return
    end

    respostas = build_respostas
    if respostas.any? && respostas.all?(&:valid?) && respostas.all?(&:save)
      redirect_to avaliacoes_path, notice: "Respostas enviadas com sucesso."
    else
      @questoes = @avaliacao.template.questoes
      flash.now[:alert] = "Preencha todas as questões."
      render :responder, status: :unprocessable_entity
    end
  end

  def resultados
    @questoes = @avaliacao.template.questoes.includes(:respostas)
    @total_respostas = Resposta.where(avaliacao: @avaliacao).select(:user_id).distinct.count
  end

  def exportar_csv
    respostas = Resposta.where(avaliacao: @avaliacao)

    if respostas.empty?
      redirect_to resultados_avaliacao_path(@avaliacao),
                  alert: 'Não existem respostas para exportar'
      return
    end

    csv_data = CSV.generate(headers: true) do |csv|
      csv << ['Aluno', 'Questão', 'Resposta']

      respostas.includes(:user, :questao).each do |resposta|
        csv << [
          resposta.user.name,
          resposta.questao.enunciado,
          resposta.texto
        ]
      end
    end

    send_data csv_data,
              filename: "avaliacao_#{@avaliacao.id}.csv",
              type: 'text/csv'
  end  

  private

  def set_avaliacao
    @avaliacao = Avaliacao.find(params[:id])
  end

  def avaliacao_params
    params.require(:avaliacao).permit(:template_id, :turma_id, :data_inicio, :data_fim, :tipo)
  end

  def ja_respondeu?
    Resposta.exists?(user: current_user, avaliacao: @avaliacao)
  end

  def build_respostas
    (params[:respostas]&.to_unsafe_h || {}).map do |questao_id, texto|
      Resposta.new(user: current_user, avaliacao: @avaliacao,
                   questao_id: questao_id, texto: texto)
    end
  end
end
