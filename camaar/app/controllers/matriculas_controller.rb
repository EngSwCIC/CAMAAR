class MatriculasController < ApplicationController
  def index
    matriculas = Matricula.all
    render json: matriculas, status: :ok
  end

  def create
    matricula = Matricula.new(matricula_params)
    matricula.save!
    render json: matricula, status: :created
  rescue StandardError => e
    render json: e, status: :bad_request
  end

  def delete
    matricula = Matricula.find(params[:id])
    matricula.destroy!
    render json: { message: "Matricula Deleted." }, status: :ok
  rescue StandardError => e
    render json: e, status: :not_found
  end

  private

  def matricula_params
    params.require(:matricula).permit(:turma_id, :user_id)
  end
end
