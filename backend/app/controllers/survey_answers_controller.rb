class SurveyAnswersController < ApplicationController
  def create
    enrollment = Enrollment.find_by!(member_id: params[:member_id], cclass_id: params[:cclass_id])
    survey_answers = SurveyAnswer.new(enrollment: enrollment, survey_id: params[:survey_id])
    survey_answers.save!
    params.require(:answers).each do |answer|
      a = Answer.new(answer.permit(:survey_question_id, :content)) #(:selected_options, :custom_option)
      a.survey_answer_id = survey_answers.id
      a.save!
      if a.survey_question.question_type == 'Caixa de Seleção'
        options = answer.require(:selected_options).map(&:to_i)
        custom_option = answer.require(:custom_option)

        options.each do |option|
          SelectedOption.create(option_id: option, answer_id: a.id)
        end

        SelectedOption.create(custom_option: custom_option, answer_id: a.id) if custom_option
      end

    end
    head(:created)
  rescue StandardError => e
    render json: { message: e }, status: :bad_request
  end
end
