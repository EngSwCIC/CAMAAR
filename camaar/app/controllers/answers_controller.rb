class AnswersController < ApplicationController
  before_action :set_user_data
  layout "user"

  def create
    occupation = current_user.occupation

    case occupation
    when "discente"
      answers_params = params[:answers]

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
  end

  def show
    @form = Form.find_by_id(params[:id])
    @form_questions = FormQuestion.where(form_id: @form.id)
    @subject_class = SubjectClass.find_by_id(@form.subject_class_id)

    @answers = {
      "text" => [],
      "multiple_choice" => {
        1 => 0,
        2 => 0,
        3 => 0,
        4 => 0,
        5 => 0,
      },
    }

    @form_questions.each do |question|
      if @form.role == "discente"
        answers = StudentAnswer.where(question_id: question.id)
        answers.each do |answ|
          body = JSON.parse(answ.body)
          case question.question_type
          when "text"
            @answers["text"] << body
          when "multiple_choice"
            5.times.each do |i|
              @answers["multiple_choice"][i] += 1 if body["answer"][i]
            end
          end
        end
      else
        @answers[question] = TeacherAnswer.where(question_id: question.id)
      end
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
      answer_body = answer
    end

    return answer_body.to_json
  end
end
