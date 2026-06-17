class RespostasController < ApplicationController
  layout "dashboard"

  def create
    @formulario = Formulario.find(params[:formulario_id])

    if @formulario.deadline < Time.current
      redirect_to formularios_path, alert: "Avaliação encerrada"
      return
    end

    if Resposta.exists?(formulario: @formulario, user: current_user)
      redirect_to formularios_path, alert: "Você já respondeu esta avaliação"
      return
    end

    # Simple validation check
    missing_answers = false
    @formulario.perguntas.where(obrigatoria: true).each do |p|
      if params[:respostas][p.id.to_s].blank?
        missing_answers = true
        break
      end
    end

    if missing_answers
      flash[:alert] = "Por favor, responda todas as questões obrigatórias"
      @perguntas = @formulario.perguntas
      render "formularios/show", status: :unprocessable_entity
      return
    end

    Resposta.transaction do
      params[:respostas].each do |pergunta_id, conteudo|
        Resposta.create!(
          formulario: @formulario,
          user: current_user,
          pergunta_id: pergunta_id,
          conteudo: conteudo
        )
      end
    end

    redirect_to formularios_path, notice: "Avaliação submetida com sucesso!"
  rescue => e
    flash[:alert] = "Erro ao enviar avaliação: #{e.message}"
    @perguntas = @formulario.perguntas
    render "formularios/show", status: :unprocessable_entity
  end
end
