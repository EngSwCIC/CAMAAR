class RespostasController < ApplicationController
  before_action :require_login

  def create
    @formulario = Formulario.find_by(id: params[:formulario_id])

    unless @formulario
      redirect_to avaliacoes_path, alert: "Formulário não encontrado." and return
    end

    estudante = current_usuario.estudante
    unless estudante
      redirect_to avaliacoes_path, alert: "Você não tem permissão para responder este formulário." and return
    end

    turma_ids = estudante.matriculas.where(trancado: [false, nil]).pluck(:turma_id)
    unless turma_ids.include?(@formulario.turma_id) && @formulario.publico_estudante
      redirect_to avaliacoes_path, alert: "Você não tem permissão para responder este formulário." and return
    end

    if RespostaFormulario.exists?(formulario: @formulario, usuario: current_usuario)
      redirect_to avaliacoes_path, alert: "Você já respondeu este formulário." and return
    end

    @pergunta_formularios = @formulario.pergunta_formularios
    answers = params[:respostas] || {}
    missing = @pergunta_formularios.any? { |pf| answers[pf.id.to_s].blank? }

    if missing
      flash.now[:alert] = "Por favor, responda todas as questões obrigatórias."
      render "formularios/show", status: :unprocessable_entity and return
    end

    resposta = RespostaFormulario.new(formulario: @formulario, usuario: current_usuario)

    if resposta.save
      redirect_to avaliacoes_path, notice: "Sua resposta foi registrada com sucesso."
    else
      flash.now[:alert] = "Erro ao registrar resposta."
      render "formularios/show", status: :unprocessable_entity
    end
  end
end
