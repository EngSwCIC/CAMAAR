class AnswersController < ApplicationController
  def create
    @form = Form.find(params[:form_id])
    @form_questions = FormQuestion.where(form_id: @form.id)

    @form_questions.each do |form_question|
      answer_params = params[:answers][form_question.id.to_s]
      
      if current_user.teacher?
        TeacherAnswer.create(
          question_type: form_question.question_type,
          answers: answer_params,
          form_question_id: form_question.id,
          teacher_id: current_user.id,
        )
      else
        StudentAnswer.create(
          question_type: form_question.question_type,
          answers: answer_params,
          form_question_id: form_question.id,
          student_id: current_user.id,
        )
      end
    end

    redirect_to some_path
  end

  def show
    @form = Form.find_by_id(params[:id])
    @form_questions = FormQuestion.where({ form_id: @form.id })
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
        answers = StudentAnswer.where({ question_id: question.id })
        answers.each do |answ|
          body = JSON.parse(answ.body)
          case question.question_type
          when "text"
            @answers["text"] << body
          when "multiple_choice"
            5.times.each do |i|
              if body["options"][i]
                @answers["multiple_choice"][i] += 1
              end
            end
          end
        end
      else
        @answers[question] = TeacherAnswer.where({ question_id: question.id })
      end
    end
  end
end
