##
# Classe Controller que define as ações capazes de serem feitas para manipular um Survey
# por meio da aplicação

class SurveysController < ApplicationController
  before_action :set_survey, only: %i[ show update destroy ]
  before_action :set_surveys, only: %i[ index open ]

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

  def show(status = nil)
    render json: @survey
  end

  ##
  # Método que cria um novo survey
  # O método não recebe nenhum parâmetro e não retorna nenhum valor
  # Ao ser evocado ele cria um novo survey no banco de dados da aplicação
  #
  def create
    @survey = Survey.new(
      set_survey_params
    )
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

    ##
    # Método para instanciar os params de Surveys
    # O método recebe os parâmetros name, description, expiration_date, semester, role_id, survey_questions_attributes,
    # question_options_attributes e likert_scale_questions_attributes
    # Ele não retorna nenhum valor e nem tem algum efeito colateral
    def set_survey_params
      params.require(:survey).permit(
        :name,
        :description,
        :expiration_date,
        :semester,
        :role_id,
        {:survey_questions_attributes => [
          :question_number,
          :question,
          :optional,
          :question_type_id,
          {:question_options_attributes => [
            :option_number,
            :content
          ]},
          {:likert_scale_questions_attributes => [
            :question,
            :question_number,
            :scale_points
          ]}
        ]},
      )
    end
end
