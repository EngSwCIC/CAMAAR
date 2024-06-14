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
          teacher_id: current_user.id
        )
      else
        StudentAnswer.create(
          question_type: form_question.question_type,
          answers: answer_params,
          form_question_id: form_question.id,
          student_id: current_user.id
        )
      end
    end

    redirect_to some_path
  end
end
