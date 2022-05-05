class SurveyAnswersController < ApplicationController
  def create
    enrollment = Enrollment.find_by!(member_id: params[:member_id], cclass_id: params[:cclass_id])
    survey_answers = SurveyAnswer.new(enrollment: enrollment, survey_id: params[:survey_id])
    survey_answers.save! if params.require(:answers)
    params.require(:answers).each do |answer|
      a = Answer.new(answer.permit(:survey_question_id, :content))
      a.content = nil if a.survey_question.question_type == 'Caixa de Seleção'
      a.survey_answer_id = survey_answers.id
      a.save!
      if a.survey_question.question_type == 'Caixa de Seleção'
        if answer[:selected_options]
          answer[:selected_options].map(&:to_i).each do |option|
            SelectedOption.create!(option_id: option, answer_id: a.id)
          end
        end

        custom_option = answer.permit(:custom_option)[:custom_option]
        SelectedOption.create!(custom_option: custom_option, answer_id: a.id) if custom_option
      end
    end
    head(:created)
  rescue StandardError => e
    render json: { message: e }, status: :bad_request
  end
end
