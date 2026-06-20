class DepartamentosController < ApplicationController
  before_action :require_login
  before_action :require_coordinator
  before_action :set_departamento

  def index
    @turmas = @departamento.materias.flat_map(&:turmas).uniq
    @formularios = Formulario.joins(turma: :materia).where(materia: { departamento_id: @departamento.id })
  end

  def show
    turmas_do_dep = @departamento.materias.flat_map(&:turmas).uniq
    @turma = turmas_do_dep.find { |t| t.id == params[:id].to_i }

    unless @turma
      redirect_to departamento_path, alert: "A turma não pertence ao seu departamento." and return
    end

    @formularios = Formulario.where(turma: @turma)
    @formularios_disponiveis = Formulario.joins(turma: :materia)
      .where(materia: { departamento_id: @departamento.id })
      .where.not(turma: @turma)
  end

  private

  def set_departamento
    @departamento = current_usuario.admin&.departamento
    unless @departamento
      redirect_to root_path, alert: "Você não está associado a nenhum departamento."
    end
  end
end
