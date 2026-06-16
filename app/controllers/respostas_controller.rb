class RespostasController < ApplicationController
  before_action :authenticate_user!

  # POST /formularios/:formulario_id/respostas  (issue #2)
  # Recebe params[:respostas] => { question_id => valor } e grava uma
  # resposta por questão para o usuário atual.
  def create
    @formulario = Formulario.find(params[:formulario_id])

    unless participante?(@formulario)
      redirect_to formularios_path, alert: "Você não está matriculado nesta turma." and return
    end

    if @formulario.respondido_por?(current_user)
      redirect_to formularios_path, alert: "Você já respondeu este formulário." and return
    end

    respostas = params[:respostas] || {}

    expected_question_count = @formulario.questions.count
    if respostas.keys.size < expected_question_count || respostas.values.any?(&:blank?)
      flash[:alert] = "Existem questões obrigatórias não respondidas."
      redirect_to formulario_path(@formulario) and return
    end

    begin
      Resposta.transaction do
        respostas.each do |question_id, valor|
          Resposta.create!(
            formulario: @formulario,
            user: current_user,
            question_id: question_id,
            valor: valor
          )
        end
      end

      redirect_to formularios_path, notice: "Respostas enviadas. Obrigado!"
    rescue ActiveRecord::RecordInvalid => e
      redirect_to formulario_path(@formulario), alert: "Erro ao enviar respostas: #{e.message}"
    end
  end

  private

  def participante?(formulario)
    current_user.enrollments.discentes.exists?(turma_id: formulario.turma_id)
  end
end
