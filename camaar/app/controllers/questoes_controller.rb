class QuestoesController < ApplicationController
  def index
    questoes = Questao.all
    render json: questoes, status: :ok
  end

  def show
    questao = Questao.find(params[:id])
    render json: questao, status: :ok
  rescue StandardError => e
    render json: e, status: :not_found
  end

  def create
    questao = Questao.new(questao_params)
    questao.save!
    render json: questao, status: :created
  rescue StandardError => e
    render json: e, status: :bad_request
  end

  def update
    questao = Questao.find(params[:id])
    questao.update!(questao_params)
    render json: questao, status: :ok
  rescue StandardError => e
    render json: e, status: :bad_request
  end

  def delete
    questao = Questao.find(params[:id])
    questao.destroy!
    render json: { message: "Questao deleted." }, status: :ok
  rescue StandardError => e
    render json: e, status: :not_found
  end

  private

  def questao_params
    params.require(:questao).permit(:texto, :formulario_id, :template_id)
  end
end
