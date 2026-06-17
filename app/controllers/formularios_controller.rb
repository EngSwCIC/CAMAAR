class FormulariosController < ApplicationController
  layout "dashboard"

  def index
    @turmas = current_user.turmas
    @formularios = Formulario.where(turma_id: @turmas.pluck(:id))
  end

  def show
    @formulario = Formulario.find(params[:id])
    if @formulario.deadline < Time.current
      redirect_to formularios_path, alert: "Avaliação encerrada em #{@formulario.deadline.strftime('%d/%m/%Y')}"
      return
    end

    if Resposta.exists?(formulario: @formulario, user: current_user)
      @respondido = true
    end

    @perguntas = @formulario.perguntas
  end
end
