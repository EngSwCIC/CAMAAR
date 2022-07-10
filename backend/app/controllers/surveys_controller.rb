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
end
