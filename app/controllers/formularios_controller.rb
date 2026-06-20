class FormulariosController < ApplicationController
  before_action :require_login

  def index
    estudante = current_usuario.estudante
    if estudante
      turma_ids = estudante.matriculas.where(trancado: [false, nil]).pluck(:turma_id)
      @formularios = Formulario.where(turma_id: turma_ids, publico_estudante: true).order(:nome_formulario)
    else
      @formularios = Formulario.none
    end
  end

  def show
    @formulario = Formulario.find(params[:id])

    estudante = current_usuario.estudante
    unless estudante
      redirect_to avaliacoes_path, alert: "Você não tem permissão para responder este formulário." and return
    end

    turma_ids = estudante.matriculas.where(trancado: [false, nil]).pluck(:turma_id)
    unless turma_ids.include?(@formulario.turma_id) && @formulario.publico_estudante
      redirect_to avaliacoes_path, alert: "Você não tem permissão para responder este formulário." and return
    end

    @pergunta_formularios = @formulario.pergunta_formularios.order(:created_at)
  end
end
