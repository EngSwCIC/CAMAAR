class TurmasController < ApplicationController
  def index
    turmas = Turma.all
    render json: turmas, status: :ok
  end

  def show
    turma = Turma.find(params[:id])
    render json: turma, status: :ok
  end

  private

  def turma_params
    params.require(:turma).permit(:codigo, :semestre, :horario, :materia_id)
  end
end
