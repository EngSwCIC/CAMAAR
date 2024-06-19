require "csv"

class AnswersController < ApplicationController
  before_action :set_user_data
  layout "user"

  def create
    occupation = current_user.occupation

    @form = Form.find_by_id(params[:form_id])
    answers_params = params[:answers]

    if answers_params.present?
      answers_params.each do |id, answ|
        if answ.empty?
          flash[:error] = "Responda todas questões."
          redirect_to edit_form_path(@form) and return
        end
      end
    end

    @errors = []


    if params[:commit] and params[:commit] == "Enviar"
      case occupation
      when "discente"
        answers_params.each do |question_id, answer|
          @form_question = FormQuestion.find(question_id.to_i)
          next unless @form_question

          StudentAnswer.create(
            answers: create_answer_body(answer),
            form_question_id: question_id,
            student_id: @student.id,
          )
        end
      when "docente"
        answers_params = params[:answers]

        answers_params.each do |question_id, answer|
          @form_question = FormQuestion.find(question_id.to_i)
          next unless @form_question

          TeacherAnswer.create(
            answers: create_answer_body(answer),
            form_question_id: question_id,
            teacher_id: current_user.id,
          )
        end
      end

      redirect_to forms_path
    else
      flash[:warning] = @errors
      puts answers_params
      redirect_to edit_form_path(id: @form.id)
      # redirect_to "/users/forms/#{}/edit/"
    end
  end

  def create_answer_body(answer)
    question_body = JSON.parse(@form_question.body)
    answer_body = { "answers" => {} }

    if @form_question.question_type == "multiple_choice"
      question_body["options"].each do |option_number, value|
        if option_number == answer
          answer_body["answers"][option_number.to_s] = true
        else
          answer_body["answers"][option_number.to_s] = false
        end
      end
    else
      answer_body["answers"] = answer
    end

    return answer_body.to_json
  end
end
