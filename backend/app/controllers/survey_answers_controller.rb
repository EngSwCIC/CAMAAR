class SurveyAnswersController < ApplicationController
  def create
    enrollment = Enrollment.find_by!(member_id: params[:member_id], cclass_id: params[:cclass_id])
    survey_answers = SurveyAnswer.new(enrollment: enrollment, survey_id: params[:survey_id])
    survey_answers.save!
    params.require(:answers).each do |answer|
      a = Answer.new(answer.permit(:survey_question_id, :content))
      a.survey_answer_id = survey_answers.id
      a.save!
    end
    head(:created)
  rescue StandardError => e
    render json: { message: e }, status: :bad_request
  end
end
