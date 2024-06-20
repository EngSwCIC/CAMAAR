class SurveysController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    survey = Survey.new(survey_params)

    if survey.save
      render json: { message: 'Survey created successfully', survey: survey }, status: :created
    else
      render json: { errors: survey.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def survey_params
    params.require(:survey).permit(:title, questions_attributes: [:title, :question_type, options_attributes: [:text]])
  end
end
