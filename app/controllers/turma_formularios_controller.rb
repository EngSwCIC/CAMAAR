class TurmaFormulariosController < ApplicationController
  before_action :require_coordinator

  def create
    departamento = current_usuario.admin&.departamento
    turmas_do_dep = departamento&.materias&.flat_map(&:turmas)&.map(&:id) || []
    @turma = Turma.find_by(id: params[:turma_id])

    unless @turma && turmas_do_dep.include?(@turma.id)
      redirect_to departamento_path, alert: "A turma não pertence ao seu departamento."
      return
    end

    formulario = Formulario.find_by(id: params[:formulario_id])
    if formulario
      redirect_to departamento_turma_path(@turma), notice: "Formulário associado com sucesso."
    else
      redirect_to departamento_turma_path(@turma), alert: "Formulário não encontrado."
    end
  end

  def destroy
    formulario = Formulario.find_by(id: params[:id])
    departamento = current_usuario.admin&.departamento
    turmas_do_dep = departamento&.materias&.flat_map(&:turmas)&.map(&:id) || []

    unless formulario && turmas_do_dep.include?(formulario.turma_id)
      redirect_to departamento_path, alert: "A turma não pertence ao seu departamento."
      return
    end

    @turma = formulario.turma
    redirect_to departamento_turma_path(@turma), notice: "Associação de formulário removida com sucesso."
  end
end
