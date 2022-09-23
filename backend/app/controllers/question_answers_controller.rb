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
      
      @survey_answer.save!

      render json: @survey_answer
    end

    # Método usado para processar uma resposta do tipo discursiva
    def process_discursive_answer(answer, question_answer)
      question_answer.answer = answer[:content] 
      question_answer.save!
    end

    # Método usado para processar uma resposta do tipo likert
    def process_likert_answers(question_answer, likert_answers)
      likert_answers.each do |likert_answer|
        likert_question = LikertScaleAnswer.new(
          answer: LikertScaleAnswer.map_likert_options(likert_answer[:content]),
          likert_scale_question_id: likert_answer[:likert_question_id],
          question_answer_id: question_answer.id).save!
      end
    end

    # Método usado para processar uma resposta do tipo múltipla escolha
    def process_multiple_choice_answer(answer, survey_question_id)
      QuestionOption.new(content: answer[:content], option_number: answer[:option_number], survey_question_id: survey_question_id).save!
    end


    ##
    # Métodos privados
    private

    # Método usado para criar um novo SurveyAnswer, com base em novo membro, survey e cclass
    def create_params
      @member = Member.find(params[:member_id])
      @survey = Survey.find(params[:survey_id])
      @cclass = Cclass.find(params[:cclass_id])
      @survey_answer = SurveyAnswer.new(member_id: @member.id, survey_id: @survey.id, cclass_id: @cclass.id)
    end


    # Método usado para verificar se há alguma resposta obrigatória que não foi preenchida
    def missing_required_answers(required_answers)
      missing_answers = []
      question_type = ""
      required_answers.each do |required_answer|
        question_type = required_answer[:question_type][:name]
        if question_type == "likert_scale" 
          missing_answers.push(question_type) if required_answer[:likert_answers_attributes].any? {|likert_answer| likert_answer[:content].nil? || likert_answer[:content].blank? }
        else
          missing_answers.push(question_type) if required_answer[:content].nil? || required_answer[:content].blank?
        end
      end
      return missing_answers.size > 0
    end


    # Método usado para processar as respostas de um SurveyAnswer
    def process_answers(answers)
      answers.each do |answer|
        question_answer = QuestionAnswer.new
        survey_question = SurveyQuestion.find(answer[:survey_question_id])

        question_answer.survey_answer = @survey_answer
        question_answer.survey_question = survey_question
        question_answer_name = answer[:question_type][:name]

        question_answer.save!
        
        if question_answer_name == "discursive"
          process_discursive_answer(answer, question_answer)
        elsif question_answer_name == "likert_scale"
          process_likert_answers(question_answer, answer[:likert_answers_attributes])
        elsif question_answer_name == "multiple_choice"
          process_multiple_choice_answer(answer, survey_question.id)
        end
    end

  end
  end