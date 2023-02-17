# frozen_string_literal: true

##
# Classe Controller que define as ações capazes de serem feitas para manipular um Survey
# por meio da aplicação
class SurveysController < ApplicationController
  before_action :set_survey, only: %i[show update destroy]
  before_action :set_surveys, only: %i[index open]

  ##
  # Método que renderiza todos os +Surveys+ armazenados no banco de dados
  #
  # Responde renderizando uma resposta com todos Surveys no formato JSON e
  # um status `ok (200)`

  def index
    render json: @surveys
  end

  ##
  # Método que renderiza todos os+Surveys+ armazenados no banco de dados
  # que não estão expirados
  #
  # Responde renderizando uma resposta com todos Surveys não expirados no formato JSON e
  # um status `ok (200)`

  def open
    @surveys = @surveys.select do |survey|
      survey.is_expired? == false
    end

    index
  end

  ##
  # Método que renderiza um +Survey+ cujo +id+ foi passado
  # por parâmetro (+params[:id]+).
  #
  # Responde renderizando uma resposta com o Survey no formato JSON e
  # um status `ok (200)`

  def show(_status = nil)
    if @survey
      render json: @survey
    else
      render json: { error: 'Survey not found' }, status: :not_found
    end
  end

  def create
    @survey = Survey.new(survey_params)

    if @survey.save
      render json: @survey
    else
      render json: @survey.errors, status: :unprocessable_entity
    end
  end

  private

  ##
  # Método que armazena todos os +Surveys+ na variável de class +@surveys+

  def set_surveys
    @surveys = Survey.all
  end

  ##
  # Método que armazena +Surveys+ cujo +id+ foi recebido via parâmetros na variável de class +@survey+

  def set_survey
    @survey = Survey.find(params[:id])
  end

  def survey_params
    params.require(:survey).permit(
      :name,
      :description,
      :expiration_date,
      :semester,
      :role_id,
      { survey_questions_attributes: [
        :question_number,
        :question,
        :optional,
        :question_type_id,
        { question_options_attributes: %i[
          option_number
          content
        ] },
        {
          likert_scale_questions_attributes: %i[
            question
            question_number
            scale_points
          ]
        }
      ] }
    )
  end
end
