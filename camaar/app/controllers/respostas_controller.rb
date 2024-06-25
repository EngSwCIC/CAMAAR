class RespostasController < ApplicationController
  def index
    respostas = Resposta.all
    render json: respostas, status: :ok
  end

  def show
    resposta = Resposta.find(params[:id])
    render json: resposta, status: :ok
  rescue StandardError => e
    render json: e, status: :not_found
  end

  def create
    resposta = Resposta.new(resposta_params)
    resposta.save!
    render json: resposta, status: :created
  rescue StandardError => e
    render json: e, status: :bad_request
  end

  def update
    resposta = Resposta.find(params[:id])
    resposta.update!(resposta_params)
    render json: resposta, status: :ok
  rescue StandardError => e
    render json: e, status: :bad_request
  end

  def delete
    resposta = Resposta.find(params[:id])
    resposta.destroy!
    render json: { message: "Resposta deleted." }, status: :ok
  rescue StandardError => e
    render json: e, status: :not_found
  end

  private

  def resposta_params
    params.require(:resposta).permit(:texto, :formulario_id, :questao_id)
  end
end
