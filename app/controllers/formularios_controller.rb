# app/controllers/formularios_controller.rb
class FormulariosController < ApplicationController
  before_action :exigir_discente!
  before_action :set_formulario, only: [ :show ]

  # GET /formularios
  def index
    @turmas = discente_atual.turmas.includes(:disciplina)

    turmas_ids              = discente_atual.turmas.pluck(:id)
    respondidos_ids         = discente_atual.envio_formularios.pluck(:formulario_id)
    base                    = Formulario.where(turma_id: turmas_ids).includes(:turma, :template)

    @formularios_pendentes  = base.abertos.where.not(id: respondidos_ids).order(prazo: :asc)
    @formularios_respondidos = base
                                .joins(:envio_formularios)
                                .where(envio_formularios: { discente_id: discente_atual.id })
                                .order("envio_formularios.enviado_em desc")
    @formularios_fechados   = base.fechados.where.not(id: respondidos_ids).order(prazo: :desc)
  end

  # GET /formularios/:id
  def show
    if discente_atual.ja_respondeu?(@formulario)
      redirect_to minha_resposta_formulario_path(@formulario),
        notice: "Você já respondeu este formulário."
      return
    end

    unless @formulario.aberto?
      redirect_to formularios_path, alert: "O prazo para responder este formulário já encerrou."
      return
    end

    unless discente_atual.turmas.include?(@formulario.turma)
      redirect_to formularios_path, alert: "Você não tem acesso a este formulário."
      return
    end

    @questoes = @formulario.questoes.includes(questao_template: :opcao_questoes)
  end

  # GET /formularios/:id/minha_resposta
  def minha_resposta
    @formulario = Formulario.find(params[:id])
    @envio      = discente_atual.envio_formularios.find_by(formulario: @formulario)

    unless @envio
      redirect_to formularios_path, alert: "Você ainda não respondeu este formulário."
      return
    end

    unless discente_atual.turmas.include?(@formulario.turma)
      redirect_to formularios_path, alert: "Você não tem acesso a este formulário."
      return
    end

    @respostas = @envio.respostas.includes(questao: { questao_template: :opcao_questoes })
  end

  private

  def set_formulario
    @formulario = Formulario.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to formularios_path, alert: "Formulário não encontrado." and return
  end
end
