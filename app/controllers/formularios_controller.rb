class FormulariosController < ApplicationController
  before_action :exigir_discente!
  before_action :set_formulario, only: [ :show ]

  def index
    @turmas = discente_atual.turmas

    @formularios_pendentes = formularios_pendentes
    @formularios_respondidos = formularios_respondidos
    @formularios_fechados = formularios_fechados
  end

  def show
    return redirect_to_minha_resposta if formulario_respondido?
    return redirect_formulario_fechado unless @formulario.aberto?
    return redirect_sem_acesso_formulario unless discente_tem_acesso_ao_formulario?

    @questoes = @formulario.questoes.includes(questao_template: :opcao_questoes)
  end

  def minha_resposta
    @formulario = Formulario.find(params[:id])
    @envio = discente_atual.envio_formularios.find_by(formulario: @formulario)

    return redirect_sem_resposta unless @envio
    return redirect_sem_acesso_formulario unless discente_atual.turmas.include?(@formulario.turma)

    @respostas = @envio.respostas.includes(questao: { questao_template: :opcao_questoes })
  end

  private

  def turmas_ids
    @turmas_ids ||= discente_atual.turmas.pluck(:id)
  end

  def respondidos_ids
    @respondidos_ids ||= discente_atual.envio_formularios.pluck(:formulario_id)
  end

  def formularios_base
    @formularios_base ||= Formulario.where(turma_id: turmas_ids).includes(:turma, :template)
  end

  def formularios_pendentes
    formularios_base.abertos.where.not(id: respondidos_ids).order(prazo: :asc)
  end

  def formularios_respondidos
    formularios_base
      .joins(:envio_formularios)
      .where(envio_formularios: { discente_id: discente_atual.id })
      .order("envio_formularios.enviado_em desc")
  end

  def formularios_fechados
    formularios_base.fechados.where.not(id: respondidos_ids).order(prazo: :desc)
  end

  def set_formulario
    @formulario = Formulario.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to formularios_path, alert: "Formulário não encontrado." and return
  end

  def formulario_respondido?
    discente_atual.ja_respondeu?(@formulario)
  end

  def redirect_to_minha_resposta
    redirect_to minha_resposta_formulario_path(@formulario),
                notice: "Você já respondeu este formulário."
  end

  def redirect_formulario_fechado
    redirect_to formularios_path,
                alert: "O prazo para responder este formulário já encerrou."
  end

  def redirect_sem_acesso_formulario
    redirect_to formularios_path,
                alert: "Você não tem acesso a este formulário."
  end

  def redirect_sem_resposta
    redirect_to formularios_path,
                alert: "Você ainda não respondeu este formulário."
  end

  def discente_tem_acesso_ao_formulario?
    discente_atual.turmas.include?(@formulario.turma)
  end
end
