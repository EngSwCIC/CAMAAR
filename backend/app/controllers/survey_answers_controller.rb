##
# Classe Controller que define as ações capazes de serem feitas para manipular um SurveyAnswer
# por meio da aplicação

class SurveyAnswersController < ApplicationController
  # before_action :authenticate_user!

  ##
  # Método usado para criação de um novo +SurveyAnswer+ usando valores
  # recebidos via parâmetro das requisição POST HTTP
  #
  # Responde renderizando uma resposta com o SurveyAnswer criado no formato JSON e 
  # status +ok (200)+ em caso de sucesso, ou renderizando uma resposta com os erros
  # de criação do SurveyAnswer no formato JSON e status +unprocessable_entity (422)+
  # em caso de erro durante a criação

  def create
    # @current_user = get_user_from_token
    # @member = Member.find(@current_user.member_id)

    @survey_answer = SurveyAnswer.new(survey_answer_params)

    if @survey_answer.save
      render json: @survey_answer
    else
      render json: @survey_answer.errors, status: :unprocessable_entity
    end
  end

  private

  # Funcao para decodificar o JWT
  # def get_user_from_token
  #   puts request.headers['Authorization']
  #   jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1], 
  #     ENV['JWT_SECRET_KEY']).first
  #   user_id = jwt_payload['sub']
  #   user = User.find(user_id.to_s)
  # end

  ##
  # Método que filtra parametros desejados para criação de +SurveyAnswer+

  def survey_answer_params
    params.require(:survey_answer)
            .permit(
              :survey_id,
              :cclass_id,
              :member_id,
              answers_attributes: [
                :survey_question_id,
                :content,
                :question_type,
                likert_answers_attributes: [:likert_question_id, :content]
              ]
            )
  end
end
