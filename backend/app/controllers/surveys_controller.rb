class SurveysController < ApplicationController

  # TODO: Adicionar options as questoes de caixa de selecao
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
