class MatriculasController < ApplicationController
  def index
    matriculas = Matricula.all
    # render json array_serializer(matriculas), status: :ok
    render json: matriculas, status: :ok
  end

  # def new
    # @matricula = Matricula.new
  # end

  # def create
  #   matricula = Matricula.new(matricula_params)
  #   matricula.save!
  #   render json: matricula, status: :created
  # rescue StandardError => e
  #   render json: e, status: :bad_request
  # end

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

  # def array_serializer(matriculas)
  #   MatriculaSerializer.new.(matriculas, each_serializer: MatriculaSerializer).to_json
  # end

  # def serializer(matricula)
  #     MatriculaSerializer.new.serialized_json(matricula)
  # end
end
