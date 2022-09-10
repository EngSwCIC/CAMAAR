##
# Classe Controller que define as ações capazes de serem feitas para manipular um SurveyAnswer
# por meio da aplicação

class QuestionAnswersController < ApplicationController
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
    @member = Member.find(params[:member_id])
    @survey = Survey.find(params[:survey_id])
    @cclass = Cclass.find(params[:cclass_id])
    @survey_answer = SurveyAnswer.new(member_id: @member.id, survey_id: @survey.id, cclass_id: @cclass.id)
    
    if @survey_answer.valid? && params[:answers_attributes].present?
      params[:answers_attributes].each do |answer|
          @question_answer = QuestionAnswer.new
          @survey_question = SurveyQuestion.find(answer[:survey_question_id])

          @question_answer.survey_answer = @survey_answer
          @question_answer.survey_question = @survey_question


          @question_answer.save!
          
          if answer[:question_type][:name] == "discursive"
            @question_answer.answer = answer[:content] 
          elsif answer[:question_type][:name] == "likert_scale"
            answer[:likert_answers_attributes].each do |likert_answer|
              likert_question = LikertScaleAnswer.new(
                answer: LikertScaleAnswer.map_likert_options(likert_answer[:content]),
                likert_scale_question_id: likert_answer[:likert_question_id],
                question_answer_id: @question_answer.id).save!
            end
          elsif answer[:question_type][:name] == "multiple_choice"
            question_option = QuestionOption.new(
              content: answer[:content],
              option_number: answer[:option_number],
              survey_question_id: @survey_question.id).save!
          end
          
      end
    end
    
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
end