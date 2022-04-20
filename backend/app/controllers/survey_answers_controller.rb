class SurveyAnswersController < ApplicationController
  before_action :set_survey_answer, only: %i[ show update destroy ]

  # GET /survey_answers
  def index
    @survey_answers = SurveyAnswer.all

    render json: @survey_answers
  end

  # GET /survey_answers/1
  def show
    render json: @survey_answer
  end

  # POST /survey_answers
  def create
    @survey_answer = SurveyAnswer.new(survey_answer_params)

    if @survey_answer.save
      render json: @survey_answer, status: :created, location: @survey_answer
    else
      render json: @survey_answer.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /survey_answers/1
  def update
    if @survey_answer.update(survey_answer_params)
      render json: @survey_answer
    else
      render json: @survey_answer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /survey_answers/1
  def destroy
    @survey_answer.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey_answer
      @survey_answer = SurveyAnswer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def survey_answer_params
      params.fetch(:survey_answer, {})
    end
end
