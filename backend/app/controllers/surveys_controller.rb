class SurveysController < ApplicationController

  ##
  # Método para obter a pesquisa desejada
  #
  # O método recebe como parâmetro apenas o +id+ (int) do questionário
  #
  # Método não retorna nada, mas renderiza um json com todas as informações
  # do questionário encontrado, incluindo as perguntas contidas nele,
  # estas podendo conter também opções, caso sejam perguntas de caixa de seleção.
  #
  # Levanta um erro caso não exista nenhum questionário com o id passado como parâmetro e
  # renderiza uma mensagem como um json informando que não foi possível encontrar o questionário

  def show
    survey = Survey.find(params[:id])
    render json: survey.to_json(
      only: [:id, :name, :description, :semester],
      include: { survey_questions: {
        only: [:question_type, :question, :optional], include: { options: { only: :option } }
      }}
    ), status: :ok
  rescue StandardError
    render json: { message: "Questionário não encontrado" } , status: :not_found
  end
end
