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
  # Método que renderiza o relatório de um determinado semestre
  # com suas questões tipo Likert e suas respostas. O semestre pode ser recebido pelo
  # query param semester (+params[:semester]+), o valor padrão é o semestre atual.
  #
  # Responde renderizando uma resposta com os +Surveys+ daquele semestre 
  # no formato JSON e um status `ok (200)`
  def reports
    # TODO: tornar essa rota privada para admins (quando tivermos essa feature)
    # TODO: achar um jeito de associar o cclass com as repostas do tipo likert

    # caso o semestre não seja passado, assume o semestre atual
    @semester = params[:semester] || '2021.2'

    @surveys = Survey
      .select('surveys.*')
      .where('surveys.semester': @semester)
      .map { |survey| {
        id: survey.id,
        name: survey.name,
        semester: survey.semester,
        survey_questions: self.class.extract_survey_likert_questions_with_answers(survey)
      } }

    render json: @surveys
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
    # Método que extrai as questões do tipo +Likert+ de um +Survey+ com suas respostas
    def self.extract_survey_likert_questions_with_answers(survey)
      # question_type_id = 3 é o id do tipo de questão Likert
      survey.survey_questions.where('question_type_id': 3).map do |question| 
        {
          question: question.question,
          likert_scale_questions: self.extract_likert_questions_with_answers(question)
        }
      end
    end

    ##
    # Método que extrai as informações das questões do tipo +Likert+ com suas respostas
    def self.extract_likert_questions_with_answers(question)
      question.likert_scale_questions.map do |likert_question| 
        {
          id: likert_question.id,
          question: likert_question.question,
          scale_points: likert_question.scale_points,
          answers: self.extract_likert_answers(likert_question)
        }
      end
    end

    ##
    # Método que extrai as respostas de uma questão do tipo +Likert+
    def self.extract_likert_answers(likert_question)
      likert_question.likert_scale_answers.map { |answer| answer.answer }
    end
end
