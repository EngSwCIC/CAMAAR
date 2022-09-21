##
# Classe Controller que define as ações capazes de serem feitas para manipular um SurveyAnswer
# por meio da aplicação

class QuestionAnswersController < ApplicationController
  # before_action :authenticate_user!
  before_action :create_params, only: [:create]
    
    ##
    # Método usado para criação de um novo +SurveyAnswer+ usando valores
    # recebidos via parâmetro das requisição POST HTTP
    #
    # Responde renderizando uma resposta com o SurveyAnswer criado no formato JSON e 
    # status +ok (200)+ em caso de sucesso, ou renderizando uma resposta com os erros
    # de criação do SurveyAnswer no formato JSON e status +unprocessable_entity (422)+
    # em caso de erro durante a criação
    
    def create
      answers_attributes = params[:answers_attributes]
      required_answers = answers_attributes.select { |answer| answer[:required] }

      if missing_required_answers(required_answers)
        errors = @survey_answer.errors
        errors.add(:base, "Preencha todas as respostas obrigatórias.")
        render json:errors, status: :unprocessable_entity
        return
      end

      if @survey_answer.valid? && answers_attributes.present?
        process_answers(answers_attributes)
      end
      
      if survey_answer.save
        render json: survey_answer
      else
        render json: survey_answer.errors, status: :unprocessable_entity
      end
    end
    
    private

    def create_params
      @member = Member.find(params[:member_id])
      @survey = Survey.find(params[:survey_id])
      @cclass = Cclass.find(params[:cclass_id])
      @survey_answer = SurveyAnswer.new(member_id: @member.id, survey_id: @survey.id, cclass_id: @cclass.id)
    end
    
    def missing_required_answers(required_answers)
      required_answers.each do |required_answer|
        if required_answer[:question_type][:name] == "likert_scale" 
          return required_answer[:likert_answers_attributes].any? {|likert_answer| likert_answer[:content].nil? }
        end
        required_answer[:content].nil?
      end
    end

    def process_answers(answers)
      answers.each do |answer|
        question_answer = QuestionAnswer.new
        survey_question = SurveyQuestion.find(answer[:survey_question_id])

        question_answer.survey_answer = survey_answer
        question_answer.survey_question = survey_question
        question_answer.name = answer[:question_type][:name]

        question_answer.save!
        
        if question_answer.name == "discursive"
          process_discursive_answer(question_answer)
        elsif question_answer.name == "likert_scale"
          process_discursive_answer(question_answer, answer[:likert_answers_attributes])
        elsif question_answer.name == "multiple_choice"
          process_multiple_choice_answer(answer, survey_question.id)
        end
    end

    def process_discursive_answer(question_answer)
      question_answer.answer = answer[:content] 
      question_answer.save!
    end
    
    def process_likert_answers(question_answer, likert_answers)
      likert_answers.each do |likert_answer|
        likert_question = LikertScaleAnswer.new(
          answer: LikertScaleAnswer.map_likert_options(likert_answer[:content]),
          likert_scale_question_id: likert_answer[:likert_question_id],
          question_answer_id: question_answer.id).save!
      end
    end

    def process_multiple_choice_answer(answer, survey_question_id)
      QuestionOption.new(content: answer[:content], option_number: answer[:option_number], survey_question_id: survey_question_id).save!
    end

  end
    
    # Funcao para decodificar o JWT
    # def get_user_from_token
    #   puts request.headers['Authorization']
    #   jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1], 
    #     ENV['JWT_SECRET_KEY']).first
    #   user_id = jwt_payload['sub']
    #   user = User.find(user_id.to_s)
    # end
  end